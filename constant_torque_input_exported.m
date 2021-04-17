classdef constant_torque_input_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        InstructionsSelectinputforeachjointandclickonAddinputLabel  matlab.ui.control.Label
        EnterInputEditFieldLabel      matlab.ui.control.Label
        EnterInputEditField           matlab.ui.control.NumericEditField
        JointNumberSpinnerLabel       matlab.ui.control.Label
        JointNumberSpinner            matlab.ui.control.Spinner
        AddInputButton                matlab.ui.control.Button
        PlotJointValuesVsTimeButton   matlab.ui.control.Button
        PlotJointVelocitiesVsTimeButton  matlab.ui.control.Button
        DoneButton                    matlab.ui.control.Button
        SimulationTimeEditFieldLabel  matlab.ui.control.Label
        SimulationTimeEditField       matlab.ui.control.NumericEditField
    end

    
    properties (Access = public)
        Property % Description
        user_control_input = 0; 
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: AddInputButton
        function AddInputButtonPushed(app, event)
            temp_control_input = app.EnterInputEditField.Value;
            app.user_control_input = [app.user_control_input; temp_control_input]; 
        end

        % Button pushed function: DoneButton
        function DoneButtonPushed(app, event)
            %Send the user contol input to workspace
            n = evalin('base', 'dof')
            updated_user_control = app.user_control_input(2:n+1)
            assignin('base', 'user_control_input', updated_user_control);
            done; 
           
            
        end

        % Button pushed function: PlotJointValuesVsTimeButton
        function PlotJointValuesVsTimeButtonPushed(app, event)
            data_q_ct = evalin('base','plot_q_contant_torque');
            data_t = evalin('base', 'plot_time_constant_torque')
            n = evalin('base', 'dof')
            hold off
            for i=1:n
                plot(data_t, data_q_ct(:,i))
                xlabel('Time (in seconds)')
                ylabel('Joint Values (in radians)')
                grid on
                hold on
            end  
        end

        % Button pushed function: PlotJointVelocitiesVsTimeButton
        function PlotJointVelocitiesVsTimeButtonPushed(app, event)
            data_qd_ct = evalin('base', 'plot_qdot_constant_torque')
            data_t = evalin('base', 'plot_time_constant_torque')
            n = evalin('base', 'dof')
            hold off
            for i=1:n
                plot(data_t, data_qd_ct(:,i))
                xlabel('Time (in seconds)')
                ylabel('Joint Velocities (in radians/s)')
                grid on
                hold on
            end  
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 752 281];
            app.UIFigure.Name = 'UI Figure';

            % Create InstructionsSelectinputforeachjointandclickonAddinputLabel
            app.InstructionsSelectinputforeachjointandclickonAddinputLabel = uilabel(app.UIFigure);
            app.InstructionsSelectinputforeachjointandclickonAddinputLabel.FontWeight = 'bold';
            app.InstructionsSelectinputforeachjointandclickonAddinputLabel.Position = [37 217 652 22];
            app.InstructionsSelectinputforeachjointandclickonAddinputLabel.Text = 'Instructions: Select input for each joint and click on Add input. After entering inputs for all joints click on Done';

            % Create EnterInputEditFieldLabel
            app.EnterInputEditFieldLabel = uilabel(app.UIFigure);
            app.EnterInputEditFieldLabel.HorizontalAlignment = 'right';
            app.EnterInputEditFieldLabel.Position = [252 186 64 22];
            app.EnterInputEditFieldLabel.Text = 'Enter Input';

            % Create EnterInputEditField
            app.EnterInputEditField = uieditfield(app.UIFigure, 'numeric');
            app.EnterInputEditField.Position = [331 186 100 22];

            % Create JointNumberSpinnerLabel
            app.JointNumberSpinnerLabel = uilabel(app.UIFigure);
            app.JointNumberSpinnerLabel.HorizontalAlignment = 'right';
            app.JointNumberSpinnerLabel.Position = [28 186 77 22];
            app.JointNumberSpinnerLabel.Text = 'Joint Number';

            % Create JointNumberSpinner
            app.JointNumberSpinner = uispinner(app.UIFigure);
            app.JointNumberSpinner.Position = [120 186 100 22];

            % Create AddInputButton
            app.AddInputButton = uibutton(app.UIFigure, 'push');
            app.AddInputButton.ButtonPushedFcn = createCallbackFcn(app, @AddInputButtonPushed, true);
            app.AddInputButton.Position = [494 186 100 22];
            app.AddInputButton.Text = 'Add Input';

            % Create PlotJointValuesVsTimeButton
            app.PlotJointValuesVsTimeButton = uibutton(app.UIFigure, 'push');
            app.PlotJointValuesVsTimeButton.ButtonPushedFcn = createCallbackFcn(app, @PlotJointValuesVsTimeButtonPushed, true);
            app.PlotJointValuesVsTimeButton.Position = [37 79 209 36];
            app.PlotJointValuesVsTimeButton.Text = ' Plot Joint Values Vs Time';

            % Create PlotJointVelocitiesVsTimeButton
            app.PlotJointVelocitiesVsTimeButton = uibutton(app.UIFigure, 'push');
            app.PlotJointVelocitiesVsTimeButton.ButtonPushedFcn = createCallbackFcn(app, @PlotJointVelocitiesVsTimeButtonPushed, true);
            app.PlotJointVelocitiesVsTimeButton.Position = [331 79 237 32];
            app.PlotJointVelocitiesVsTimeButton.Text = 'Plot Joint Velocities Vs Time';

            % Create DoneButton
            app.DoneButton = uibutton(app.UIFigure, 'push');
            app.DoneButton.ButtonPushedFcn = createCallbackFcn(app, @DoneButtonPushed, true);
            app.DoneButton.Position = [292 145 100 22];
            app.DoneButton.Text = 'Done';

            % Create SimulationTimeEditFieldLabel
            app.SimulationTimeEditFieldLabel = uilabel(app.UIFigure);
            app.SimulationTimeEditFieldLabel.HorizontalAlignment = 'right';
            app.SimulationTimeEditFieldLabel.Position = [37 145 91 22];
            app.SimulationTimeEditFieldLabel.Text = 'Simulation Time';

            % Create SimulationTimeEditField
            app.SimulationTimeEditField = uieditfield(app.UIFigure, 'numeric');
            app.SimulationTimeEditField.Position = [134 145 100 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = constant_torque_input_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end