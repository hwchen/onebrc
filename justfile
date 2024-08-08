run file:
    odin build . -o:aggressive -no-bounds-check -disable-assert && time ./onebrc {{file}}

run-zig file:
    zig build-exe main.zig -OReleaseFast -femit-bin=onebrc-zig && time ./onebrc-zig {{file}}

bench:
    odin build . -o:aggressive -no-bounds-check -disable-assert && \
    poop './onebrc measurement_data.txt'
