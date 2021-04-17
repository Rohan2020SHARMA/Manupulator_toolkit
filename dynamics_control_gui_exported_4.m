classdef dynamics_control_gui_exported_4 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        DynamicsControlsFig             matlab.ui.Figure
        ManipulatorDynamicsandControlLabel  matlab.ui.control.Label
        ControllerLabel                 matlab.ui.control.Label
        DesiredendeffectorpositionLabel  matlab.ui.control.Label
        EditField                       matlab.ui.control.NumericEditField
        EditField_2                     matlab.ui.control.NumericEditField
        EditField_3                     matlab.ui.control.NumericEditField
        GototheDesiredPositionButton    matlab.ui.control.Button
        ListofPlotsLabel                matlab.ui.control.Label
        PlotJointvaluesVsTimeButton     matlab.ui.control.Button
        PlotJointVelocitiesVsTimeButton  matlab.ui.control.Button
        PlotErrorVsTimeButton           matlab.ui.control.Button
        ShowDynamicEquationButton       matlab.ui.control.Button
        GeneralizedForcesTextAreaLabel  matlab.ui.control.Label
        ControltouseLabel               matlab.ui.control.Label
        SelectoneButtonGroup            matlab.ui.container.ButtonGroup
        PDControlwithgravitycompensationButton  matlab.ui.control.RadioButton
        InverseDynamicscontrolButton    matlab.ui.control.RadioButton
        PlotResultsLabel                matlab.ui.control.Label
        KpEditFieldLabel                matlab.ui.control.Label
        KpEditField                     matlab.ui.control.NumericEditField
        EnterProportionalandDerivativeGainsLabel  matlab.ui.control.Label
        KdEditFieldLabel                matlab.ui.control.Label
        KdEditField                     matlab.ui.control.EditField
        GeneralizedForcesTextArea       matlab.ui.control.TextArea
    end


    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: ShowDynamicEquationButton
        function ShowDynamicEquationButtonPushed(app, event)
            tau = evalin('base', 'main_u');
            array_string = char(tau);
            array_string([1:8, end-1:end]) = []

            temp_size = size(array_string);
            temp_n = temp_size(2);
            display_array = blanks(1);
            temp_array = blanks(1);
            for i=1:temp_n
                if array_string(i) == ',' || i==temp_n  
                    display_array = [display_array newline temp_array];
                    temp_array = blanks(1);
                else
                    temp_array = strcat(temp_array, array_string(i));
                end
    
            end
            display_array = strcat(display_array, ']');
            app.GeneralizedForcesTextArea.Value = display_array; 
            
            constant_torque_input_exported; 
            
        end

        % Button pushed function: GototheDesiredPositionButton
        function GototheDesiredPositionButtonPushed(app, event)
            
            xd = [app.EditField.Value; app.EditField_2.Value; app.EditField_3.Value; 0; 0; 0];
            assignin('base', 'xd', xd); 
            Kp = app.KpEditField.Value; 
            Kd = str2double(app.KdEditField.Value); 
            if Kp ~= 0 && Kd ~= 0
                assignin('base', 'Kp', Kp);
                assignin('base', 'Kd', Kd);
            else
                assignin('base', 'Kp', 2); 
                assignin('base', 'Kd', 4); 
            end
            if app.PDControlwithgravitycompensationButton.Value 
                fprintf('PD Control with Gravity compensation')
                PD_motion_control;
            elseif app.InverseDynamicscontrolButton.Value
                fprintf('Inverse Dynamics Control')
                inverse_dynamics_control; 
            end
        end

        % Button pushed function: PlotJointvaluesVsTimeButton
        function PlotJointvaluesVsTimeButtonPushed(app, event)
            %Get the joint values from the workspace
            data_q = evalin('base','log_q'); 
            data_time = evalin('base', 'log_time');
            n = evalin('base', 'dof');
            %Getting the legends array
            labels_array = 'q1';
            for i=1:n
                temp_q = strcat('q', num2str(i+1)); 
                labels_array = [labels_array; temp_q];                
            end
            %labels_array = labels_array(2:n,:);
            hold off
            for i=1:n
                plot(data_time(1,:), data_q(i,:));
                xlabel('Time (in seconds)');
                ylabel('Joint values (in radians)');
                legend(labels_array); 
                hold on
                grid on
            end
        end

        % Button pushed function: PlotJointVelocitiesVsTimeButton
        function PlotJointVelocitiesVsTimeButtonPushed(app, event)
            hold off
            data_qd = evalin('base', 'log_qd');
            data_time = evalin('base', 'log_time');
            n = evalin('base', 'dof');
            %Getting the legends array
            labels_array = 'qdot1';
            for i=1:n
                temp_q = strcat('qdot', num2str(i+1)); 
                labels_array = [labels_array; temp_q];                
            end
            %labels_array = labels_array(2:n,:);
            
            for i=1:n
                plot(data_time(1,:), data_qd(i,:));
                xlabel('Time (in Seconds)');
                ylabel('Joint velocities (in radians/s)');
                legend(labels_array);
                hold on;
                grid on;
            end
        end

        % Button pushed function: PlotErrorVsTimeButton
        function PlotErrorVsTimeButtonPushed(app, event)
            hold off
            data_distance_error = evalin('base', 'log_distance_error'); 
            data_time = evalin('base', 'log_time'); 
            n = evalin('base', 'dof'); 
            for i = 1:n
                plot(data_time, data_distance_error);
                xlabel('Time (in seconds)');
                ylabel('Distance (in m) between current and desired end effector position ');
                hold on;
                grid on;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create DynamicsControlsFig and hide until all components are created
            app.DynamicsControlsFig = uifigure('Visible', 'off');
            app.DynamicsControlsFig.Position = [100 100 919 762];
            app.DynamicsControlsFig.Name = 'UI Figure';

            % Create ManipulatorDynamicsandControlLabel
            app.ManipulatorDynamicsandControlLabel = uilabel(app.DynamicsControlsFig);
            app.ManipulatorDynamicsandControlLabel.HorizontalAlignment = 'center';
            app.ManipulatorDynamicsandControlLabel.FontSize = 16;
            app.ManipulatorDynamicsandControlLabel.FontWeight = 'bold';
            app.ManipulatorDynamicsandControlLabel.Position = [4 730 917 22];
            app.ManipulatorDynamicsandControlLabel.Text = 'Manipulator Dynamics and Control';

            % Create ControllerLabel
            app.ControllerLabel = uilabel(app.DynamicsControlsFig);
            app.ControllerLabel.BackgroundColor = [0.0745 0.6235 1];
            app.ControllerLabel.HorizontalAlignment = 'center';
            app.ControllerLabel.FontSize = 14;
            app.ControllerLabel.FontWeight = 'bold';
            app.ControllerLabel.Position = [5 452 914 22];
            app.ControllerLabel.Text = 'Controller';

            % Create DesiredendeffectorpositionLabel
            app.DesiredendeffectorpositionLabel = uilabel(app.DynamicsControlsFig);
            app.DesiredendeffectorpositionLabel.FontWeight = 'bold';
            app.DesiredendeffectorpositionLabel.Position = [20 416 172 22];
            app.DesiredendeffectorpositionLabel.Text = 'Desired end effector position';

            % Create EditField
            app.EditField = uieditfield(app.DynamicsControlsFig, 'numeric');
            app.EditField.Position = [234 416 88 22];

            % Create EditField_2
            app.EditField_2 = uieditfield(app.DynamicsControlsFig, 'numeric');
            app.EditField_2.Position = [350 416 88 22];

            % Create EditField_3
            app.EditField_3 = uieditfield(app.DynamicsControlsFig, 'numeric');
            app.EditField_3.Position = [461 416 88 22];

            % Create GototheDesiredPositionButton
            app.GototheDesiredPositionButton = uibutton(app.DynamicsControlsFig, 'push');
            app.GototheDesiredPositionButton.ButtonPushedFcn = createCallbackFcn(app, @GototheDesiredPositionButtonPushed, true);
            app.GototheDesiredPositionButton.Position = [299 156 219 34];
            app.GototheDesiredPositionButton.Text = 'Go to the Desired Position';

            % Create ListofPlotsLabel
            app.ListofPlotsLabel = uilabel(app.DynamicsControlsFig);
            app.ListofPlotsLabel.HorizontalAlignment = 'center';
            app.ListofPlotsLabel.FontSize = 14;
            app.ListofPlotsLabel.FontWeight = 'bold';
            app.ListofPlotsLabel.Position = [299 299 152 22];
            app.ListofPlotsLabel.Text = 'List of Plots';

            % Create PlotJointvaluesVsTimeButton
            app.PlotJointvaluesVsTimeButton = uibutton(app.DynamicsControlsFig, 'push');
            app.PlotJointvaluesVsTimeButton.ButtonPushedFcn = createCallbackFcn(app, @PlotJointvaluesVsTimeButtonPushed, true);
            app.PlotJointvaluesVsTimeButton.Position = [36 47 193 32];
            app.PlotJointvaluesVsTimeButton.Text = 'Plot Joint values Vs Time';

            % Create PlotJointVelocitiesVsTimeButton
            app.PlotJointVelocitiesVsTimeButton = uibutton(app.DynamicsControlsFig, 'push');
            app.PlotJointVelocitiesVsTimeButton.ButtonPushedFcn = createCallbackFcn(app, @PlotJointVelocitiesVsTimeButtonPushed, true);
            app.PlotJointVelocitiesVsTimeButton.Position = [310 47 193 32];
            app.PlotJointVelocitiesVsTimeButton.Text = 'Plot Joint Velocities Vs Time';

            % Create PlotErrorVsTimeButton
            app.PlotErrorVsTimeButton = uibutton(app.DynamicsControlsFig, 'push');
            app.PlotErrorVsTimeButton.ButtonPushedFcn = createCallbackFcn(app, @PlotErrorVsTimeButtonPushed, true);
            app.PlotErrorVsTimeButton.Position = [557 47 193 32];
            app.PlotErrorVsTimeButton.Text = 'Plot Error Vs Time ';

            % Create ShowDynamicEquationButton
            app.ShowDynamicEquationButton = uibutton(app.DynamicsControlsFig, 'push');
            app.ShowDynamicEquationButton.ButtonPushedFcn = createCallbackFcn(app, @ShowDynamicEquationButtonPushed, true);
            app.ShowDynamicEquationButton.Position = [165 700 146 22];
            app.ShowDynamicEquationButton.Text = 'Show Dynamic Equation';

            % Create GeneralizedForcesTextAreaLabel
            app.GeneralizedForcesTextAreaLabel = uilabel(app.DynamicsControlsFig);
            app.GeneralizedForcesTextAreaLabel.HorizontalAlignment = 'right';
            app.GeneralizedForcesTextAreaLabel.FontWeight = 'bold';
            app.GeneralizedForcesTextAreaLabel.Position = [36 693 116 36];
            app.GeneralizedForcesTextAreaLabel.Text = 'Generalized Forces';

            % Create GeneralizedForcesTextArea
            app.GeneralizedForcesTextArea = uitextarea(app.DynamicsControlsFig);
            app.GeneralizedForcesTextArea.Position = [22 493 879 197];

            % Create ControltouseLabel
            app.ControltouseLabel = uilabel(app.DynamicsControlsFig);
            app.ControltouseLabel.FontWeight = 'bold';
            app.ControltouseLabel.Position = [22 382 87 22];
            app.ControltouseLabel.Text = 'Control to use';

            % Create SelectoneButtonGroup
            app.SelectoneButtonGroup = uibuttongroup(app.DynamicsControlsFig);
            app.SelectoneButtonGroup.Title = 'Select one';
            app.SelectoneButtonGroup.Position = [125 298 320 106];

            % Create PDControlwithgravitycompensationButton
            app.PDControlwithgravitycompensationButton = uiradiobutton(app.SelectoneButtonGroup);
            app.PDControlwithgravitycompensationButton.Text = 'PD Control with gravity compensation';
            app.PDControlwithgravitycompensationButton.Position = [11 60 224 22];
            app.PDControlwithgravitycompensationButton.Value = true;

            % Create InverseDynamicscontrolButton
            app.InverseDynamicscontrolButton = uiradiobutton(app.SelectoneButtonGroup);
            app.InverseDynamicscontrolButton.Text = 'Inverse Dynamics control';
            app.InverseDynamicscontrolButton.Position = [11 38 157 22];

            % Create PlotResultsLabel
            app.PlotResultsLabel = uilabel(app.DynamicsControlsFig);
            app.PlotResultsLabel.BackgroundColor = [0.4667 0.6745 0.1882];
            app.PlotResultsLabel.HorizontalAlignment = 'center';
            app.PlotResultsLabel.FontSize = 14;
            app.PlotResultsLabel.FontWeight = 'bold';
            app.PlotResultsLabel.Position = [5 105 911 22];
            app.PlotResultsLabel.Text = 'Plot Results';

            % Create KpEditFieldLabel
            app.KpEditFieldLabel = uilabel(app.DynamicsControlsFig);
            app.KpEditFieldLabel.HorizontalAlignment = 'right';
            app.KpEditFieldLabel.Position = [78 230 25 22];
            app.KpEditFieldLabel.Text = 'Kp';

            % Create KpEditField
            app.KpEditField = uieditfield(app.DynamicsControlsFig, 'numeric');
            app.KpEditField.Position = [118 230 100 22];

            % Create EnterProportionalandDerivativeGainsLabel
            app.EnterProportionalandDerivativeGainsLabel = uilabel(app.DynamicsControlsFig);
            app.EnterProportionalandDerivativeGainsLabel.Position = [23 259 218 22];
            app.EnterProportionalandDerivativeGainsLabel.Text = 'Enter Proportional and Derivative Gains';

            % Create KdEditFieldLabel
            app.KdEditFieldLabel = uilabel(app.DynamicsControlsFig);
            app.KdEditFieldLabel.HorizontalAlignment = 'right';
            app.KdEditFieldLabel.Position = [278 230 25 22];
            app.KdEditFieldLabel.Text = 'Kd';

            % Create KdEditField
            app.KdEditField = uieditfield(app.DynamicsControlsFig, 'text');
            app.KdEditField.Position = [318 230 100 22];

            % Show the figure after all components are created
            app.DynamicsControlsFig.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = dynamics_control_gui_exported_4

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.DynamicsControlsFig)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.DynamicsControlsFig)
        end
    end
end