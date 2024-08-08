package onebrc

import "core:bufio"
import "core:bytes"
import "core:fmt"
import "core:os"
import "core:sort"
import "core:strconv"
import "core:strings"

main :: proc() {
	path := os.args[1]
	f, _ := os.open(path)
	read_buf: [4096 * 8]u8
	rdr: bufio.Reader
	bufio.reader_init_with_buf(&rdr, os.stream_from_handle(f), read_buf[:])

	city_agg := make(map[string]Agg)

	idx := 0
	for {
		line, rerr := bufio.reader_read_slice(&rdr, '\n')
		if rerr != nil {
			break
		}
		split_idx := bytes.index_byte(line, ';')
		city := string(line[:split_idx])
		temp, _ := strconv.parse_f64(string(line[split_idx + 1:]))
		agg, ok := &city_agg[city]
		if ok {
			agg.min = min(agg.min, temp)
			agg.max = max(agg.max, temp)
			agg.total += temp
			agg.count += 1
		} else {
			city_key, _ := strings.clone(city)
			city_agg[city_key] = Agg {
				min   = temp,
				max   = temp,
				total = temp,
				count = 1,
			}
		}
	}

	// format
	sorted_cities := make([dynamic]string)
	for city, _ in city_agg {
		append(&sorted_cities, city)
	}
	sort.quick_sort(sorted_cities[:])

	fmt.print("{")
	for city, idx in sorted_cities {
		agg := city_agg[city]
		mean := agg.total / f64(agg.count)
		fmt.printf("%s=%.1f/%.1f/%.1f", city, agg.min, mean, agg.max)
		if idx < len(sorted_cities) - 1 {
			fmt.print(", ")
		}
	}
	fmt.print("}\n")
}

Agg :: struct {
	min:   f64,
	max:   f64,
	total: f64,
	count: int,
}
