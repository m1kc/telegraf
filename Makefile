all: main

main: main.d
	dmd main.d -O -ofmain

clean:
	rm -f main.o main
