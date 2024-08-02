package onebrc

import "core:bufio"
import "core:fmt"
import "core:os"

main :: proc() {
	path := os.args[1]
	f, _ := os.open(path)
	read_buf: [4096 * 8]u8
	scanner: bufio.Scanner
	bufio.scanner_init_with_buffer(&scanner, os.stream_from_handle(f), read_buf[:])

	idx := 0
	for {
		if !bufio.scanner_scan(&scanner) {
			break
		}
		idx += 1
	}
	fmt.println(idx)
}
