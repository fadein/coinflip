#!/usr/bin/perl
# http://ascii-table.com/ansi-escape-sequences-vt-100.php

$| = 1;

my ($up, $right) = (9, 15);
my $height = 11;
my @anim = qw(/ - \\ |);

my $delay = 0.1;

# hide cursor
print "\e[?25l";

print <<'DUDE';


   /"""""
  |  (')')
  C     _)
   \   _|
    \__/
   <___Y>
  /  \ :\\
 /   |  :|\
 |___|  :|/\
  | |   :|\ \
  \ \   :| \ \_
   \ \==L|  \\\
   ///` ||
    |   ||
    |   ||
    |   ||
    |   ||
    [___]]
jgs (____))
DUDE

# Move cursor up 7, right 10

# position cursor right after the coin
print "\e[${up}A\e[${right}C";

# coin go up

select undef, undef, undef, $delay;
print "\e[1Di\e[1D\e[1A|";
select undef, undef, undef, $delay;

foreach my $i (1 .. $height) {
	print "\e[1D \e[1D\e[1A@{[$anim[$i % $#anim]]}";
	select undef, undef, undef, $delay;
}


# coin go down
foreach my $i (1 .. $height + 1) {
	select undef, undef, undef, $delay;
	print "\e[1D \e[1D\e[1B@{[$anim[$i % $#anim]]}";
}
print "\e[1D \e[1B\e[1D\e[1A-";

# put the cursor back beneath the guy
print "\e[${right}D\e[${up}B";

# print the result of the flip
printf "It's %s\n", int(rand() * 2) % 2 ? 'heads' : 'tails';

if (@ARGV) {
	my @alternatives = grep { $_ !~ /or/i } @ARGV;
	print "You should go with '@{[ $alternatives[int(rand($#alternatives))] ]}'\n";
}

#restore cursor
print "\e[?25h";


__DATA__
\e[nA up n lines
\e[nB down n lines
\e[nC right n cols
\e[nD left n cols
