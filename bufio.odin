package onebrc

import "core:io"
import "core:mem"

// Reader is a buffered wrapper for an io.Reader
Reader :: struct {
	buf:                         []byte,
	buf_allocator:               mem.Allocator,
	rd:                          io.Reader, // reader
	r, w:                        int, // read and write positions for buf
	err:                         io.Error,
	last_byte:                   int, // last byte read, invalid is -1
	last_rune_size:              int, // size of last rune read, invalid is -1
	max_consecutive_empty_reads: int,
}

reader_init_with_buf :: proc(b: ^Reader, rd: io.Reader, buf: []byte) {
	reader_reset(b, rd)
	b.buf_allocator = {}
	b.buf = buf
}

_reader_read_new_chunk :: proc(b: ^Reader) -> io.Error {
	if b.r > 0 {
		copy(b.buf, b.buf[b.r:b.w])
		b.w -= b.r
		b.r = 0
	}

	if b.w >= len(b.buf) {
		return .Buffer_Full
	}

	if b.max_consecutive_empty_reads <= 0 {
		b.max_consecutive_empty_reads = DEFAULT_MAX_CONSECUTIVE_EMPTY_READS
	}

	// read new data, and try a limited number of times
	for i := b.max_consecutive_empty_reads; i > 0; i -= 1 {
		n, err := io.read(b.rd, b.buf[b.w:])
		if n < 0 {
			return err if err != nil else .Negative_Read
		}
		b.w += n
		if err != nil {
			b.err = err
			return nil
		}
		if n > 0 {
			return nil
		}
	}
	b.err = .No_Progress
	return nil
}

_reader_consume_err :: proc(b: ^Reader) -> io.Error {
	err := b.err
	b.err = nil
	return err
}

// reader_read_byte reads and returns a single byte
// If no byte is available, it return an error
reader_read_byte :: proc(b: ^Reader) -> (c: byte, err: io.Error) {
	b.last_rune_size = -1
	for b.r == b.w {
		if b.err != nil {
			return 0, _reader_consume_err(b)
		}
		_reader_read_new_chunk(b) or_return
	}
	c = b.buf[b.r]
	b.r += 1
	b.last_byte = int(c)
	return
}

reader_reset :: proc(b: ^Reader, r: io.Reader) {
	b.rd = r
	b.r, b.w = 0, 0
	b.err = nil
	b.last_byte = -1
	b.last_rune_size = -1
}

DEFAULT_MAX_CONSECUTIVE_EMPTY_READS :: 128
