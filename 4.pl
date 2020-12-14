#!/usr/bin/perl

$quantity = 0;

open(DATA, '04traffic-seed0.97.txt') or die "couldn't open file 04traffic-seed0.97.txt, $!";

print "fid\tsender\t-->\treceiver\n";

while (<DATA>) {
	@x = split(' ');
	if ($x[2] eq 'connecting') {
    if ($quantity >= 5) {
      last;
    }

    print "$quantity\t$x[1]\t-->\t$x[4]\n";
    $quantity++;
	}
}
close(DATA);