run:
    odin build . -o:aggressive && time ./onebrc measurement_data.txt

run-zig:
    zig build-exe main.zig -Doptimize=ReleaseFast -femit-bin=onebrc-zig && time ./onebrc-zig measurement_data.txt
