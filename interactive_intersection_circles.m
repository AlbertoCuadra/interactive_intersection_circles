function interactive_intersection_circles()
    % Plot circles until the user right-clicks. If the circles intersect,
    % they will change to the same random color.
    
    % Definitions
    L = 100; % Length theta vector
    theta = linspace(0, 2*pi, L); % [rad]
    % Initialization
    n = 0; % Counter of circles
    x = zeros(1, 200);
    y = zeros(1, 200);
    r = zeros(1, 200);
    obj_circles = matlab.graphics.chart.primitive.Line.empty(0, 100);
    % Create figure
    set_figure();
    % While loop (stop when user press right click)
    while true
        % Increase counter
        n = n + 1;
        % Define random color in case intersection
        random_color = rand(1,3);
        % Do until user press right click
        cursor_selection = get(gcf, 'SelectionType');
        if strcmpi(cursor_selection, 'alt')
            break;
        end
        % Get circle
        [x(n), y(n), r(n), obj_circles(n)] = get_cicle(theta);
        % Check intersections
        for i = 1:n-1
            FLAG_INTERSECTION = compute_intersection(x(n), y(n), r(n), x(i), y(i), r(i));
            if FLAG_INTERSECTION
                obj_circles(i).Color = random_color;
                obj_circles(n).Color = random_color;
            end
        end
    end
end

% SUB-PASS FUNCTIONS
function A = area_circle(r)
    % Compute area circle
    A = pi * r.^2;
    fprintf('Area: %.4f\n', A);
end

function [x, y] = cartisian_coordinate(x0, y0, r, theta)
    % Compute position circle in cartisian coordinate system
    x = r .* cos(theta) + x0;
    y = r .* sin(theta) + y0;
end

function [x, y] = get_center_point()
    % Get n points from current figure
    fprintf('Left click on the figure to choose a center point. \n');
    [x, y] = ginput(1);
    plot(x, y, '+', 'Color', 'r', 'LineWidth', 1);
end

function [x, y] = get_perimeter_point()
    % Get n points from current figure
    fprintf('Left click on the figure to choose a point on the circle''s perimeter. \n');
    [x, y] = ginput(1);
    plot(x, y);
end

function obj_circle = plot_circle(x, y)
    % Plot circle
    obj_circle = plot(x, y, 'Color', 'r', 'LineWidth', 2);
end

function distance = compute_distance(x1, y1, x2, y2)
    % Compute Euclidean distance
    distance = sqrt((y2 - y1).^2 + (x2 - x1).^2);
end

function [x1, y1, r, obj_circle] = get_cicle(theta)
    % Get and plot circle

    % Get center point
    [x1, y1] = get_center_point();
    % Get perimeter point
    [x2, y2] = get_perimeter_point();
    % Compute radius
    r = compute_distance(x1, y1, x2, y2);
    % Compute area
    A = area_circle(r);
    % Print Area
    % ....
    % Get position circle in cartisian coordinate system
    [x, y] = cartisian_coordinate(x1, y1, r, theta);
    % Plot circle
    obj_circle = plot_circle(x, y);
end

function FLAG_INTERSECTION = compute_intersection(x1, y1, r1, x2, y2, r2)
    % Compute intersection
    
    % Compute Euclidean distance
    distance = compute_distance(x1, y1, x2, y2);
    % Compute sum of the radius of the two circles
    total_radius = r1 + r2;
    % Check intersection
    if distance <= total_radius && distance + min(r1, r2) >= max(r1, r2)
        FLAG_INTERSECTION = true;
    else
        FLAG_INTERSECTION = false;
    end
end

function [ax, config, fig] = set_figure(varargin)
    % Initialize figure with a standard composition
    %
    % Optional args:
    %   * ax (axis):       Figure axis
    %   * config (struct): Struct with default plot parameters
    %
    % Returns:
    %   ax (axis):         Axis of the standard figure
    %   config (struct):   Struct with default plot parameters
    %   fig (figure):      Standard figure

    % Default values
    config.linewidth = 1.8;              % Default linewidth for plots
    config.fontsize = 22;                % Default fontsize
    config.labelx = 'x';                 % Default xlabel
    config.labely = 'y';                 % Default ylabel
    % Unpack input
    if nargin > 0
        ax = varargin{1};
        if nargin > 1
            config = varargin{2};
        end
        if ~isempty(ax.XLabel)
            config.labelx = ax.XLabel;
        end
        if ~isempty(ax.YLabel)
            config.labely = ax.YLabel;
        end
    else
        fig = figure;
        set(fig,'units','normalized','innerposition',[0.1 0.1 0.5 0.6])
        ax = axes(fig);
    end
    
    set(ax,'LineWidth', config.linewidth, 'FontSize', config.fontsize-2, 'BoxStyle', 'full')
    hold(ax, 'on'); axis(ax, 'manual');
    xlabel(ax, config.labelx, 'FontSize', config.fontsize, 'interpreter', 'latex');
    ylabel(ax, config.labely, 'FontSize', config.fontsize, 'interpreter', 'latex');
    
    xlim([0 10]);
    ylim([0 10]);
end