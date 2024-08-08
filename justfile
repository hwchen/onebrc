run version file:
    odin build {{version}}.odin -file -o:aggressive -no-bounds-check -disable-assert && time ./{{version}} {{file}}

run-zig file:
    zig build-exe main.zig -OReleaseFast -femit-bin=onebrc-zig && time ./onebrc-zig {{file}}

bench:
    odin build . -o:aggressive -no-bounds-check -disable-assert && \
    poop './onebrc measurement_data.txt'
