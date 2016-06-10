.PHONY: clean

coinflip: coinflip.scm
	csc $^

clean:
	-rm -f coinflip
