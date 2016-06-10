.PHONY: clean

coinflip: coinflip.scm dude.scm
	csc $<

clean:
	-rm -f coinflip
