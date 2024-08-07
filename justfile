run:
    odin build . -o:aggressive && time ./onebrc measurement_data.txt

run-zig:
    zig build-exe main.zig -OReleaseFast -femit-bin=onebrc-zig && time ./onebrc-zig measurement_data.txt

bench:
    odin build . -o:aggressive && poop './onebrc measurement_data.txt'
