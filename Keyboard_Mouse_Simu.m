import java.awt.Robot

mouse_keys = Robot;

% Default: Move forward (W pressed)
mouse_keys.keyPress(java.awt.event.KeyEvent.VK_W);
% Default: Mouse in the center
screenSize = get(0, 'screensize');
center_x=screenSize(3)/2;
center_y=screenSize(4)/2;
mouse_keys.mouseMove(center_x,center_y);

% Stop Moving (W released)
mouse_keys.keyRelease(java.awt.event.KeyEvent.VK_W);

% Move cursor to the left
i=center_x;
while i>center_x/2
    mouse_keys.mouseMove(i,center_y);
    pause(0.01);
    i=i-20;
end

% Move cursor to the right
i=center_x;
while i<(center_x+center_x/2)
    mouse_keys.mouseMove(i,center_y);
    pause(0.01);
    i=i+20;
end