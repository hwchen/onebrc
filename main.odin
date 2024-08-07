package onebrc

import "core:bufio"
import "core:fmt"
import "core:os"

main :: proc() {
	path := os.args[1]
	f, _ := os.open(path)
	read_buf: [4096 * 8]u8
	rdr: Reader
	reader_init_with_buf(&rdr, os.stream_from_handle(f), read_buf[:])

	idx := 0
	for {
		c, berr := reader_read_byte(&rdr)
		if berr != nil {
			break
		}
		if c == '\n' {
			idx += 1
		}
	}
	fmt.println(idx)
}
