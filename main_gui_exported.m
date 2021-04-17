classdef main_gui_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        ManipulatorExplorerLabel        matlab.ui.control.Label
        ManipulatorDescriptionButtonGroup  matlab.ui.container.ButtonGroup
        DHparametersButton              matlab.ui.control.RadioButton
        FromourdatabaseButton           matlab.ui.control.RadioButton
        DropDown                        matlab.ui.control.DropDown
        jointSpinnerLabel               matlab.ui.control.Label
        jointSpinner                    matlab.ui.control.Spinner
        TypeDropDownLabel               matlab.ui.control.Label
        TypeDropDown                    matlab.ui.control.DropDown
        LimitsLabel                     matlab.ui.control.Label
        aEditFieldLabel                 matlab.ui.control.Label
        aEditField                      matlab.ui.control.NumericEditField
        alphaEditFieldLabel             matlab.ui.control.Label
        alphaEditField                  matlab.ui.control.NumericEditField
        dEditFieldLabel                 matlab.ui.control.Label
        dEditField                      matlab.ui.control.NumericEditField
        thetaEditFieldLabel             matlab.ui.control.Label
        thetaEditField                  matlab.ui.control.NumericEditField
        AddtothemanipulatorButton       matlab.ui.control.Button
        LaunchManipulatorControlButton  matlab.ui.control.Button
        MassofLinkEditFieldLabel        matlab.ui.control.Label
        MassofLinkEditField             matlab.ui.control.NumericEditField
        PositionofCOMoflinkrLabel       matlab.ui.control.Label
        xEditFieldLabel                 matlab.ui.control.Label
        xEditField                      matlab.ui.control.NumericEditField
        yEditFieldLabel                 matlab.ui.control.Label
        yEditField                      matlab.ui.control.NumericEditField
        zEditFieldLabel                 matlab.ui.control.Label
        zEditField                      matlab.ui.control.NumericEditField
        GearratioEditFieldLabel         matlab.ui.control.Label
        GearratioEditField              matlab.ui.control.NumericEditField
        InertiaofLinkLabel              matlab.ui.control.Label
        xEditField_2Label               matlab.ui.control.Label
        xEditField_2                    matlab.ui.control.NumericEditField
        yEditField_2Label               matlab.ui.control.Label
        yEditField_2                    matlab.ui.control.NumericEditField
        zEditField_2Label               matlab.ui.control.Label
        zEditField_2                    matlab.ui.control.NumericEditField
        DirectionofgravitywithrespecttobaseframeLabel  matlab.ui.control.Label
        xEditField_3Label               matlab.ui.control.Label
        xEditField_3                    matlab.ui.control.NumericEditField
        yEditField_3Label               matlab.ui.control.Label
        yEditField_3                    matlab.ui.control.NumericEditField
        MinEditFieldLabel               matlab.ui.control.Label
        MinEditField                    matlab.ui.control.NumericEditField
        MaxEditFieldLabel               matlab.ui.control.Label
        MaxEditField                    matlab.ui.control.NumericEditField
        zEditField_3Label               matlab.ui.control.Label
        zEditField_3                    matlab.ui.control.NumericEditField
        InertiaofMotorEditFieldLabel    matlab.ui.control.Label
        InertiaofMotorEditField         matlab.ui.control.NumericEditField
        
        %Adding the buttons manually for the last section where the user
        %does not know the DH parameters
        IDontKnowDHButton       matlab.ui.control.Button
        NoneOfTheAboveButton           matlab.ui.control.RadioButton
        
    end

    
    properties (Access = public)
        dh_table_row     % one row of dh table
        dh_table = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
        is_revolute_array
        scenario = 0
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: AddtothemanipulatorButton
        function AddtothemanipulatorButtonPushed(app, event)
            
            %Add the joint to the main matrix
            joint_type = app.TypeDropDown.Value
            
            if strcmp(joint_type, 'Revolute')
                app.is_revolute_array = [app.is_revolute_array; 1]
            else
                app.is_revolute_array = [app.is_revolute_array; 0]
            end
            
            
            
            %Add the joint to the main matrix
            joint_type = app.TypeDropDown.Value; 
            a = app.aEditField.Value;
            alpha = app.alphaEditField.Value;
            d = app.dEditField.Value;
            theta = app.thetaEditField.Value;
            link_mass = app.MassofLinkEditField.Value;
            gear_ratio = app.GearratioEditField.Value;
            link_inertia_x =  app.xEditField_2.Value; 
            link_inertia_y = app.yEditField_2.Value;
            link_inertia_z = app.zEditField_2.Value;
            joint_limit_min = app.MinEditField.Value;
            joint_limit_max = app.MaxEditField.Value;
            link_com_x = app.xEditField.Value;
            link_com_y = app.yEditField.Value;
            link_com_z = app.zEditField.Value;
            gravity_x = app.xEditField_3.Value;
            gravity_y = app.yEditField_3.Value;
            gravity_z = app.zEditField_3.Value; 
            motor_inertia = app.InertiaofMotorEditField.Value; 
            
            
            app.dh_table_row = [a, alpha, d, theta, link_mass, gear_ratio, link_inertia_x, link_inertia_y, link_inertia_z, link_com_x, link_com_y, link_com_z, gravity_x, gravity_y, gravity_z, motor_inertia, joint_limit_min, joint_limit_max ]
            %app.dh_table_row
            app.dh_table = [app.dh_table; app.dh_table_row];
            app.dh_table;
            fprintf('\nAdded Values to Variables\n ')
        end

        % Button pushed function: LaunchManipulatorControlButton
        function LaunchManipulatorControlButtonPushed(app, event)
            
            %Set the value for scenario
            if app.DHparametersButton.Value
                app.scenario = 1; 
                assignin('base', "main_dh_table", app.dh_table)
                assignin('base', "is_revolute_array", app.is_revolute_array)
                
            elseif app.FromourdatabaseButton.Value
                    fprintf('Database button selected')
                    if app.DropDown.Value == '2-link Planar arm'
                        app.scenario = 2;
                    elseif app.DropDown.Value == '3-link Planar arm'
                        app.scenario = 3;
                    elseif app.DropDown.Value == '2-link Cartersian'
                        fprintf('Cartesian link selected')
                        app.scenario = 4;
                    elseif app.DropDown.Value == 'SCARA            '
                        app.scenario = 5;
                    elseif app.DropDown.Value == 'Stanford         '
                        app.scenario = 6;
                    elseif app.DropDown == 'Cylindrical Arm  '
                        app.scenario = 7;
                    elseif app.DropDown == 'Spherical Wrist  '
                        app.scenario = 8;
                    end
            elseif app.NoneOfTheAboveButton.Value
                fprintf('User Does Not know DH')
                app.scenario = 9; 
                
                    
            end
            
            assignin('base', 'scenario', app.scenario); 
            closereq
            
            %assignin('base', "dh_fuu", app.dh_table)
            %assignin('caller', "a1", app.temp)
            %fprintf('assignment succesful')
            %evalin('base', 'a1')
        end
        
        % Button pushed function: IDontKnowDHParmetersButton
        function IDontKnowDHButtonPushed(app, event)
            fprintf('The GUI for answering questions to extract DH Parameters\n')
            dontknowDH_exported2; 
            
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.9216 0.9412 0.949];
            app.UIFigure.Position = [100 100 1127 805];
            app.UIFigure.Name = 'UI Figure';

            % Create ManipulatorExplorerLabel
            app.ManipulatorExplorerLabel = uilabel(app.UIFigure);
            app.ManipulatorExplorerLabel.BackgroundColor = [0.302 0.7451 0.9333];
            app.ManipulatorExplorerLabel.HorizontalAlignment = 'center';
            app.ManipulatorExplorerLabel.FontName = 'Century Schoolbook L';
            app.ManipulatorExplorerLabel.FontSize = 20;
            app.ManipulatorExplorerLabel.FontWeight = 'bold';
            app.ManipulatorExplorerLabel.Position = [10 769 1112 24];
            app.ManipulatorExplorerLabel.Text = 'Manipulator Explorer';

            % Create ManipulatorDescriptionButtonGroup
            app.ManipulatorDescriptionButtonGroup = uibuttongroup(app.UIFigure);
            app.ManipulatorDescriptionButtonGroup.Title = 'Manipulator Description';
            app.ManipulatorDescriptionButtonGroup.FontWeight = 'bold';
            app.ManipulatorDescriptionButtonGroup.Position = [5 17 184 733];

            % Create DHparametersButton
            app.DHparametersButton = uiradiobutton(app.ManipulatorDescriptionButtonGroup);
            app.DHparametersButton.Text = 'D-H parameters';
            app.DHparametersButton.Position = [15 686 107 22];
            app.DHparametersButton.Value = true;

            % Create FromourdatabaseButton
            app.FromourdatabaseButton = uiradiobutton(app.ManipulatorDescriptionButtonGroup);
            app.FromourdatabaseButton.Text = 'From our database';
            app.FromourdatabaseButton.Position = [15 411 123 22];

            % Create DropDown
            app.DropDown = uidropdown(app.UIFigure);
            %app.DropDown.Items = {'2-link Planar arm','3-link Planar arm', '2-link Cartersian', 'SCARA            ', 'Stanford        ', 'Cylindrical Arm  ', 'Spherical Wrist  '};
            app.DropDown.Items = {'2-link Planar arm','3-link Planar arm', '2-link Cartersian'};
            app.DropDown.Position = [242 428 100 22];
            app.DropDown.Value = '2-link Planar arm';

            % Create jointSpinnerLabel
            app.jointSpinnerLabel = uilabel(app.UIFigure);
            app.jointSpinnerLabel.HorizontalAlignment = 'right';
            app.jointSpinnerLabel.FontWeight = 'bold';
            app.jointSpinnerLabel.Position = [190 703 41 22];
            app.jointSpinnerLabel.Text = 'joint #';

            % Create jointSpinner
            app.jointSpinner = uispinner(app.UIFigure);
            app.jointSpinner.FontWeight = 'bold';
            app.jointSpinner.Position = [246 701 49 22];

            % Create TypeDropDownLabel
            app.TypeDropDownLabel = uilabel(app.UIFigure);
            app.TypeDropDownLabel.HorizontalAlignment = 'right';
            app.TypeDropDownLabel.FontWeight = 'bold';
            app.TypeDropDownLabel.Position = [322 701 33 22];
            app.TypeDropDownLabel.Text = 'Type';

            % Create TypeDropDown
            app.TypeDropDown = uidropdown(app.UIFigure);
            app.TypeDropDown.Items = {'Revolute', 'Prismatic'};
            app.TypeDropDown.FontWeight = 'bold';
            app.TypeDropDown.Position = [362 701 100 22];
            app.TypeDropDown.Value = 'Revolute';

            % Create LimitsLabel
            app.LimitsLabel = uilabel(app.UIFigure);
            app.LimitsLabel.FontWeight = 'bold';
            app.LimitsLabel.Position = [206 633 41 22];
            app.LimitsLabel.Text = 'Limits';

            % Create aEditFieldLabel
            app.aEditFieldLabel = uilabel(app.UIFigure);
            app.aEditFieldLabel.HorizontalAlignment = 'right';
            app.aEditFieldLabel.FontWeight = 'bold';
            app.aEditFieldLabel.Position = [216 669 25 22];
            app.aEditFieldLabel.Text = 'a';

            % Create aEditField
            app.aEditField = uieditfield(app.UIFigure, 'numeric');
            app.aEditField.FontWeight = 'bold';
            app.aEditField.Position = [246 667 24 22];

            % Create alphaEditFieldLabel
            app.alphaEditFieldLabel = uilabel(app.UIFigure);
            app.alphaEditFieldLabel.HorizontalAlignment = 'right';
            app.alphaEditFieldLabel.FontWeight = 'bold';
            app.alphaEditFieldLabel.Position = [281 668 37 22];
            app.alphaEditFieldLabel.Text = 'alpha';

            % Create alphaEditField
            app.alphaEditField = uieditfield(app.UIFigure, 'numeric');
            app.alphaEditField.Position = [333 668 21 22];

            % Create dEditFieldLabel
            app.dEditFieldLabel = uilabel(app.UIFigure);
            app.dEditFieldLabel.HorizontalAlignment = 'right';
            app.dEditFieldLabel.FontWeight = 'bold';
            app.dEditFieldLabel.Position = [374 668 25 22];
            app.dEditFieldLabel.Text = 'd';

            % Create dEditField
            app.dEditField = uieditfield(app.UIFigure, 'numeric');
            app.dEditField.FontWeight = 'bold';
            app.dEditField.Position = [414 668 25 22];

            % Create thetaEditFieldLabel
            app.thetaEditFieldLabel = uilabel(app.UIFigure);
            app.thetaEditFieldLabel.HorizontalAlignment = 'right';
            app.thetaEditFieldLabel.FontWeight = 'bold';
            app.thetaEditFieldLabel.Position = [480 668 34 22];
            app.thetaEditFieldLabel.Text = 'theta';

            % Create thetaEditField
            app.thetaEditField = uieditfield(app.UIFigure, 'numeric');
            app.thetaEditField.Position = [529 668 26 22];

            % Create AddtothemanipulatorButton
            app.AddtothemanipulatorButton = uibutton(app.UIFigure, 'push');
            app.AddtothemanipulatorButton.ButtonPushedFcn = createCallbackFcn(app, @AddtothemanipulatorButtonPushed, true);
            app.AddtothemanipulatorButton.FontWeight = 'bold';
            app.AddtothemanipulatorButton.Position = [478 492 183 47];
            app.AddtothemanipulatorButton.Text = 'Add to the manipulator';

            % Create LaunchManipulatorControlButton
            app.LaunchManipulatorControlButton = uibutton(app.UIFigure, 'push');
            app.LaunchManipulatorControlButton.ButtonPushedFcn = createCallbackFcn(app, @LaunchManipulatorControlButtonPushed, true);
            app.LaunchManipulatorControlButton.Position = [810 50 248 40];
            app.LaunchManipulatorControlButton.Text = 'Launch Manipulator Control';

            % Create MassofLinkEditFieldLabel
            app.MassofLinkEditFieldLabel = uilabel(app.UIFigure);
            app.MassofLinkEditFieldLabel.HorizontalAlignment = 'right';
            app.MassofLinkEditFieldLabel.FontWeight = 'bold';
            app.MassofLinkEditFieldLabel.Position = [621 668 78 22];
            app.MassofLinkEditFieldLabel.Text = 'Mass of Link';

            % Create MassofLinkEditField
            app.MassofLinkEditField = uieditfield(app.UIFigure, 'numeric');
            app.MassofLinkEditField.Position = [714 668 32 22];

            % Create PositionofCOMoflinkrLabel
            app.PositionofCOMoflinkrLabel = uilabel(app.UIFigure);
            app.PositionofCOMoflinkrLabel.FontWeight = 'bold';
            app.PositionofCOMoflinkrLabel.Position = [607 633 153 22];
            app.PositionofCOMoflinkrLabel.Text = 'Position of COM of link (r)';

            % Create xEditFieldLabel
            app.xEditFieldLabel = uilabel(app.UIFigure);
            app.xEditFieldLabel.HorizontalAlignment = 'right';
            app.xEditFieldLabel.Position = [771 633 25 22];
            app.xEditFieldLabel.Text = 'x';

            % Create xEditField
            app.xEditField = uieditfield(app.UIFigure, 'numeric');
            app.xEditField.Position = [811 633 24 22];

            % Create yEditFieldLabel
            app.yEditFieldLabel = uilabel(app.UIFigure);
            app.yEditFieldLabel.HorizontalAlignment = 'right';
            app.yEditFieldLabel.Position = [842 633 25 22];
            app.yEditFieldLabel.Text = 'y';

            % Create yEditField
            app.yEditField = uieditfield(app.UIFigure, 'numeric');
            app.yEditField.Position = [884 633 25 22];

            % Create zEditFieldLabel
            app.zEditFieldLabel = uilabel(app.UIFigure);
            app.zEditFieldLabel.HorizontalAlignment = 'right';
            app.zEditFieldLabel.Position = [922 633 25 22];
            app.zEditFieldLabel.Text = 'z';

            % Create zEditField
            app.zEditField = uieditfield(app.UIFigure, 'numeric');
            app.zEditField.Position = [964 633 26 22];

            % Create GearratioEditFieldLabel
            app.GearratioEditFieldLabel = uilabel(app.UIFigure);
            app.GearratioEditFieldLabel.HorizontalAlignment = 'right';
            app.GearratioEditFieldLabel.FontWeight = 'bold';
            app.GearratioEditFieldLabel.Position = [807 671 62 22];
            app.GearratioEditFieldLabel.Text = 'Gear ratio';

            % Create GearratioEditField
            app.GearratioEditField = uieditfield(app.UIFigure, 'numeric');
            app.GearratioEditField.Position = [875 670 28 22];

            % Create InertiaofLinkLabel
            app.InertiaofLinkLabel = uilabel(app.UIFigure);
            app.InertiaofLinkLabel.FontWeight = 'bold';
            app.InertiaofLinkLabel.Position = [567 560 84 22];
            app.InertiaofLinkLabel.Text = 'Inertia of Link';

            % Create xEditField_2Label
            app.xEditField_2Label = uilabel(app.UIFigure);
            app.xEditField_2Label.HorizontalAlignment = 'right';
            app.xEditField_2Label.Position = [657 561 25 22];
            app.xEditField_2Label.Text = 'x';

            % Create xEditField_2
            app.xEditField_2 = uieditfield(app.UIFigure, 'numeric');
            app.xEditField_2.Position = [689 559 35 22];

            % Create yEditField_2Label
            app.yEditField_2Label = uilabel(app.UIFigure);
            app.yEditField_2Label.HorizontalAlignment = 'right';
            app.yEditField_2Label.Position = [723 559 25 22];
            app.yEditField_2Label.Text = 'y';

            % Create yEditField_2
            app.yEditField_2 = uieditfield(app.UIFigure, 'numeric');
            app.yEditField_2.Position = [761 559 33 22];

            % Create zEditField_2Label
            app.zEditField_2Label = uilabel(app.UIFigure);
            app.zEditField_2Label.HorizontalAlignment = 'right';
            app.zEditField_2Label.Position = [801 559 25 22];
            app.zEditField_2Label.Text = 'z';

            % Create zEditField_2
            app.zEditField_2 = uieditfield(app.UIFigure, 'numeric');
            app.zEditField_2.Position = [834 559 30 22];

            % Create DirectionofgravitywithrespecttobaseframeLabel
            app.DirectionofgravitywithrespecttobaseframeLabel = uilabel(app.UIFigure);
            app.DirectionofgravitywithrespecttobaseframeLabel.FontWeight = 'bold';
            app.DirectionofgravitywithrespecttobaseframeLabel.Position = [200 598 273 22];
            app.DirectionofgravitywithrespecttobaseframeLabel.Text = 'Direction of gravity with respect to base frame';

            % Create xEditField_3Label
            app.xEditField_3Label = uilabel(app.UIFigure);
            app.xEditField_3Label.HorizontalAlignment = 'right';
            app.xEditField_3Label.Position = [484 598 25 22];
            app.xEditField_3Label.Text = 'x';

            % Create xEditField_3
            app.xEditField_3 = uieditfield(app.UIFigure, 'numeric');
            app.xEditField_3.Position = [528 598 40 22];

            % Create yEditField_3Label
            app.yEditField_3Label = uilabel(app.UIFigure);
            app.yEditField_3Label.HorizontalAlignment = 'right';
            app.yEditField_3Label.Position = [585 598 25 22];
            app.yEditField_3Label.Text = 'y';

            % Create yEditField_3
            app.yEditField_3 = uieditfield(app.UIFigure, 'numeric');
            app.yEditField_3.Position = [629 598 40 22];

            % Create zEditField_3Label
            app.zEditField_3Label = uilabel(app.UIFigure);
            app.zEditField_3Label.HorizontalAlignment = 'right';
            app.zEditField_3Label.Position = [685 598 25 22];
            app.zEditField_3Label.Text = 'z';

            % Create zEditField_3
            app.zEditField_3 = uieditfield(app.UIFigure, 'numeric');
            app.zEditField_3.Position = [729 598 40 22];

            % Create InertiaofMotorEditFieldLabel
            app.InertiaofMotorEditFieldLabel = uilabel(app.UIFigure);
            app.InertiaofMotorEditFieldLabel.HorizontalAlignment = 'right';
            app.InertiaofMotorEditFieldLabel.FontWeight = 'bold';
            app.InertiaofMotorEditFieldLabel.Position = [259 561 93 22];
            app.InertiaofMotorEditFieldLabel.Text = 'Inertia of Motor';

            % Create InertiaofMotorEditField
            app.InertiaofMotorEditField = uieditfield(app.UIFigure, 'numeric');
            app.InertiaofMotorEditField.Position = [367 561 46 22];

            % Create MinEditFieldLabel
            app.MinEditFieldLabel = uilabel(app.UIFigure);
            app.MinEditFieldLabel.HorizontalAlignment = 'right';
            app.MinEditFieldLabel.Position = [289 633 25 22];
            app.MinEditFieldLabel.Text = 'Min';

            % Create MinEditField
            app.MinEditField = uieditfield(app.UIFigure, 'numeric');
            app.MinEditField.Position = [329 633 55 22];

            % Create MaxEditFieldLabel
            app.MaxEditFieldLabel = uilabel(app.UIFigure);
            app.MaxEditFieldLabel.HorizontalAlignment = 'right';
            app.MaxEditFieldLabel.Position = [425 633 28 22];
            app.MaxEditFieldLabel.Text = 'Max';

            % Create MaxEditField
            app.MaxEditField = uieditfield(app.UIFigure, 'numeric');
            app.MaxEditField.Position = [468 633 52 22];
            
            %User does not know DH values
            % Create NoneOfTheAbove Radio button
            app.NoneOfTheAboveButton = uiradiobutton(app.ManipulatorDescriptionButtonGroup);
            app.NoneOfTheAboveButton.Text = 'None of the Above';
            app.NoneOfTheAboveButton.Position = [16 181 123 22];
            
            %Create IDontKnowDHParameters
            % Create WHATEVERRRButton
            app.IDontKnowDHButton = uibutton(app.UIFigure, 'push');
            app.IDontKnowDHButton.Position = [251 182 207 38];
            app.IDontKnowDHButton.ButtonPushedFcn = createCallbackFcn(app, @IDontKnowDHButtonPushed, true);
            app.IDontKnowDHButton.Text = 'I Dont Know DH Parameters'; 
            
            


            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = main_gui_exported

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