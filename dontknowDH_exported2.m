classdef dontknowDH_exported2 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        NumberofJointsEditFieldLabel    matlab.ui.control.Label
        NumberofJointsEditField         matlab.ui.control.NumericEditField
        ManipulatorConfigEditFieldLabel  matlab.ui.control.Label
        ManipulatorConfigEditField      matlab.ui.control.EditField
        ZaxisEditFieldLabel             matlab.ui.control.Label
        ZaxisEditField                  matlab.ui.control.EditField
        LinkLenghtsEditFieldLabel       matlab.ui.control.Label
        LinkLenghtsEditField            matlab.ui.control.EditField
        MassesoflinksEditFieldLabel     matlab.ui.control.Label
        MassesoflinksEditField          matlab.ui.control.EditField
        GearRatiosEditFieldLabel        matlab.ui.control.Label
        GearRatiosEditField             matlab.ui.control.EditField
        LimitsEditFieldLabel            matlab.ui.control.Label
        LimitsEditField                 matlab.ui.control.EditField
        DirectionofGravityEditFieldLabel  matlab.ui.control.Label
        DirectionofGravityEditField     matlab.ui.control.EditField
        InertiasofMotorsEditFieldLabel  matlab.ui.control.Label
        InertiasofMotorsEditField       matlab.ui.control.EditField
        CalculateDHButton               matlab.ui.control.Button
        InertiasofLinksEditFieldLabel   matlab.ui.control.Label
        InertiasofLinksEditField        matlab.ui.control.EditField
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: CalculateDHButton
        function CalculateDHButtonPushed(app, event)
            dof = app.NumberofJointsEditField.Value
            jtype = app.ManipulatorConfigEditField.Value 
            z = str2num(app.ZaxisEditField.Value)
            z = transpose(z); 
            linklen = str2num(app.LinkLenghtsEditField.Value) 
            masses = str2num(app.MassesoflinksEditField.Value)
            gear_ratios = str2num(app.GearRatiosEditField.Value)
            limits = str2num(app.LimitsEditField.Value)
            motor_inertias = str2num(app.InertiasofMotorsEditField.Value); 
            link_inertias = str2num(app.InertiasofLinksEditField.Value)
            gravity_direction = str2num(app.DirectionofGravityEditField.Value); 
            
            assignin('base', 'link_inertias',link_inertias)
            assignin('base', 'motor_inertias', motor_inertias)
            assignin('base', 'limits', limits); 
            assignin('base', 'gear_ratios', gear_ratios)
            assignin('base', 'link_masses', masses)
            assignin('base', 'joint_type', jtype)
            assignin('base', 'gravity_field', gravity_direction)
            assignin('base', 'dof', dof)
            
            dh = calcDH(dof, jtype, z, linklen)
            assignin('base', 'dh_mike', dh)
            
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 806 594];
            app.UIFigure.Name = 'UI Figure';

            % Create NumberofJointsEditFieldLabel
            app.NumberofJointsEditFieldLabel = uilabel(app.UIFigure);
            app.NumberofJointsEditFieldLabel.HorizontalAlignment = 'right';
            app.NumberofJointsEditFieldLabel.Position = [6 519 110 36];
            app.NumberofJointsEditFieldLabel.Text = 'Number of Joints';

            % Create NumberofJointsEditField
            app.NumberofJointsEditField = uieditfield(app.UIFigure, 'numeric');
            app.NumberofJointsEditField.Position = [211 513 219 42];

            % Create ManipulatorConfigEditFieldLabel
            app.ManipulatorConfigEditFieldLabel = uilabel(app.UIFigure);
            app.ManipulatorConfigEditFieldLabel.HorizontalAlignment = 'right';
            app.ManipulatorConfigEditFieldLabel.Position = [16 474 106 22];
            app.ManipulatorConfigEditFieldLabel.Text = 'Manipulator Config';

            % Create ManipulatorConfigEditField
            app.ManipulatorConfigEditField = uieditfield(app.UIFigure, 'text');
            app.ManipulatorConfigEditField.Position = [209 455 222 41];

            % Create CalculateDHButton
            app.CalculateDHButton = uibutton(app.UIFigure, 'push');
            app.CalculateDHButton.ButtonPushedFcn = createCallbackFcn(app, @CalculateDHButtonPushed, true);
            app.CalculateDHButton.Position = [260 39 226 48];
            app.CalculateDHButton.Text = 'Calculate DH';

            % Create LinkLenghtsEditFieldLabel
            app.LinkLenghtsEditFieldLabel = uilabel(app.UIFigure);
            app.LinkLenghtsEditFieldLabel.HorizontalAlignment = 'right';
            app.LinkLenghtsEditFieldLabel.Position = [16 411 74 22];
            app.LinkLenghtsEditFieldLabel.Text = 'Link Lenghts';

            % Create LinkLenghtsEditField
            app.LinkLenghtsEditField = uieditfield(app.UIFigure, 'text');
            app.LinkLenghtsEditField.Position = [212 402 221 38];

            % Create ZaxisEditFieldLabel
            app.ZaxisEditFieldLabel = uilabel(app.UIFigure);
            app.ZaxisEditFieldLabel.HorizontalAlignment = 'right';
            app.ZaxisEditFieldLabel.Position = [25 358 38 22];
            app.ZaxisEditFieldLabel.Text = 'Z-axis';

            % Create ZaxisEditField
            app.ZaxisEditField = uieditfield(app.UIFigure, 'text');
            app.ZaxisEditField.Position = [207 348 219 42];

            % Create MassesoflinksEditFieldLabel
            app.MassesoflinksEditFieldLabel = uilabel(app.UIFigure);
            app.MassesoflinksEditFieldLabel.HorizontalAlignment = 'right';
            app.MassesoflinksEditFieldLabel.Position = [3 299 88 22];
            app.MassesoflinksEditFieldLabel.Text = 'Masses of links';

            % Create MassesoflinksEditField
            app.MassesoflinksEditField = uieditfield(app.UIFigure, 'text');
            app.MassesoflinksEditField.Position = [106 278 173 43];

            % Create GearRatiosEditFieldLabel
            app.GearRatiosEditFieldLabel = uilabel(app.UIFigure);
            app.GearRatiosEditFieldLabel.HorizontalAlignment = 'right';
            app.GearRatiosEditFieldLabel.Position = [301 299 70 22];
            app.GearRatiosEditFieldLabel.Text = 'Gear Ratios';

            % Create GearRatiosEditField
            app.GearRatiosEditField = uieditfield(app.UIFigure, 'text');
            app.GearRatiosEditField.Position = [386 277 145 44];

            % Create LimitsEditFieldLabel
            app.LimitsEditFieldLabel = uilabel(app.UIFigure);
            app.LimitsEditFieldLabel.HorizontalAlignment = 'right';
            app.LimitsEditFieldLabel.Position = [582 299 37 22];
            app.LimitsEditFieldLabel.Text = 'Limits';

            % Create LimitsEditField
            app.LimitsEditField = uieditfield(app.UIFigure, 'text');
            app.LimitsEditField.Position = [645 280 145 41];

            % Create DirectionofGravityEditFieldLabel
            app.DirectionofGravityEditFieldLabel = uilabel(app.UIFigure);
            app.DirectionofGravityEditFieldLabel.HorizontalAlignment = 'right';
            app.DirectionofGravityEditFieldLabel.Position = [522 533 108 22];
            app.DirectionofGravityEditFieldLabel.Text = 'Direction of Gravity';

            % Create DirectionofGravityEditField
            app.DirectionofGravityEditField = uieditfield(app.UIFigure, 'text');
            app.DirectionofGravityEditField.Position = [645 509 149 46];

            % Create InertiasofMotorsEditFieldLabel
            app.InertiasofMotorsEditFieldLabel = uilabel(app.UIFigure);
            app.InertiasofMotorsEditFieldLabel.HorizontalAlignment = 'right';
            app.InertiasofMotorsEditFieldLabel.Position = [3 214 98 22];
            app.InertiasofMotorsEditFieldLabel.Text = 'Inertias of Motors';

            % Create InertiasofMotorsEditField
            app.InertiasofMotorsEditField = uieditfield(app.UIFigure, 'text');
            app.InertiasofMotorsEditField.Position = [134 189 211 47];

            % Create InertiasofLinksEditFieldLabel
            app.InertiasofLinksEditFieldLabel = uilabel(app.UIFigure);
            app.InertiasofLinksEditFieldLabel.HorizontalAlignment = 'right';
            app.InertiasofLinksEditFieldLabel.Position = [367 214 90 22];
            app.InertiasofLinksEditFieldLabel.Text = 'Inertias of Links';

            % Create InertiasofLinksEditField
            app.InertiasofLinksEditField = uieditfield(app.UIFigure, 'text');
            app.InertiasofLinksEditField.Position = [472 186 275 50];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = dontknowDH_exported2

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