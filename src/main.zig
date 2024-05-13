// raylib-zig (c) Nikolas Wipper 2023
const std = @import("std");
const rl = @import("raylib");
const Allocator = std.mem.Allocator;

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------

    // reading screen size from settings
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const parsed = try readconfig(allocator, "src/config.json");
    defer parsed.deinit();
    const config = parsed.value;

    // starting window

    rl.initWindow(config.width, config.height, "Walker");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.white);
        drawCrossHairs(config);
        drawBorder(config);

        rl.drawPixel(20, 80, rl.Color.light_gray);
        rl.drawCircle(50, 90, 5.9, rl.Color.light_gray);
        rl.drawText("Congrats! You created your first window!< test", 190, 200, 20, rl.Color.light_gray);
        //----------------------------------------------------------------------------------
    }
}

fn drawBorder(config: Config) void {
    const TopLeft = rl.Vector2.init(0.0, 0.0);
    const TopRight = rl.Vector2.init(@floatFromInt(config.width), 0.0);
    const BottomLeft = rl.Vector2.init(0.0, @floatFromInt(config.height));
    const BottomRight = rl.Vector2.init(@floatFromInt(config.width), @floatFromInt(config.height));
    rl.drawLineEx(TopLeft, TopRight, 15.0, rl.Color.black);
    rl.drawLineEx(TopRight, BottomRight, 15.0, rl.Color.black);
    rl.drawLineEx(TopLeft, BottomLeft, 15.0, rl.Color.black);
    rl.drawLineEx(BottomLeft, BottomRight, 15.0, rl.Color.black);
}

fn drawCrossHairs(config: Config) void {
    rl.drawLine(0, @divTrunc(config.height, 2), config.width, @divTrunc(config.height, 2), rl.Color.black);
    rl.drawLine(@divTrunc(config.width, 2), 0, @divTrunc(config.width, 2), config.height, rl.Color.black);
}

// reading basic settigns from a json file

// code from https://www.openmymind.net/Reading-A-Json-Config-In-Zig/

fn readconfig(allocator: Allocator, path: []const u8) !std.json.Parsed(Config) {
    const data = try std.fs.cwd().readFileAlloc(allocator, path, 512);
    defer allocator.free(data);
    return std.json.parseFromSlice(Config, allocator, data, .{ .allocate = .alloc_always });
}

const Config = struct {
    height: i32 = 600,
    width: i32 = 800,
};
