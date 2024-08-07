run:
    odin build . -o:aggressive -no-bounds-check -disable-assert && time ./onebrc measurement_data.txt

run-zig:
    zig build-exe main.zig -OReleaseFast -femit-bin=onebrc-zig && time ./onebrc-zig measurement_data.txt

bench:
    odin build . -o:aggressive -no-bounds-check -disable-assert && \
    zig build-exe main.zig -OReleaseFast -femit-bin=onebrc-zig && \
    poop './onebrc measurement_data.txt' './onebrc-zig measurement_data.txt'
