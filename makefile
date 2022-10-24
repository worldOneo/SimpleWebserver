dirs = ./*
OBJS	= $(foreach dirz, $(dirs), \
		$(patsubst %.S,%.o,$(wildcard $(dirz).S)) \
		)

OUT	 = server
AS	 = gcc

all: build

build: $(OBJS)
	$(AS) -no-pie $(OBJS) -o $(OUT)

%.o: %.S
	$(AS) $(FLAGS) -c -o $@ $<

clean:
	rm -f $(OBJS)  