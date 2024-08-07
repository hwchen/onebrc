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
    while (true) {
        const c = input.readByte() catch return;
        switch (c) {
            '\n' => idx += 1,
            else => continue,
        }
    }
    std.debug.print("{d}\n", .{idx});
}
