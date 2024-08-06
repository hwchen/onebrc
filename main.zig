const std = @import("std");

pub fn main() !void {
    var args = std.process.args();
    _ = args.next();
    const path = args.next().?;
    const f = try std.fs.cwd().openFile(path, .{});
    const rdr = f.reader();
    var brdr = std.io.bufferedReaderSize(4096 * 8, rdr);
    const input = brdr.reader();

    var idx: usize = 0;
    var buf: [64]u8 = undefined;
    while (true) {
        const line_maybe = try input.readUntilDelimiterOrEof(&buf, '\n');
        if (line_maybe) |_| {
            idx += 1;
        } else {
            break;
        }
    }
    std.debug.print("{d}\n", .{idx});
}
