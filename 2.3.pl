#!/usr/bin/perl

@send;
@recv;
$quantity = 0;
@startingTimes;
@endingTimes;
@totals;

open(DATA, '04traffic-seed0.97.txt') or die "couldn't open file 04traffic-seed0.97.txt, $!";

while (<DATA>) {
	@x = split(' ');
	if ($x[2] eq 'connecting') {
		$send[$quantity] = $x[1];
		$recv[$quantity] = $x[4];
		$startingTimes[$quantity] = 0;
		$endingTimes[$quantity] = 0;
		$totals[$quantity] = 0;
		$quantity++;
	}
}
close(DATA);

open(DATA, 'wireless1-out.tr') or die "couldn't open file wireless1-out.tr, $!";
while (<DATA>) {
	@x = split(/[' ','\[','\]',':']+/);
	if (($x[3] eq 'AGT') && ($x[6] eq 'tcp')) {
		$tmpsend = $x[13];
		$tmprecv = $x[15];
		for ($i = 0; $i < $quantity; $i++) {
			if (($tmpsend eq $send[$i]) && ($tmprecv eq $recv[$i])) {
				if (($x[0] eq 's') && !$startingTimes[$i]) {
					$startingTimes[$i] = $x[1];
					last;
				} elsif ($x[0] eq 'r'){
					$endingTimes[$i] = $x[1];
					$totals[$i] += $x[7];
				}
			}
		}
	}
} 
close(DATA);

$totalThroughput = 0;
for ($i = 0; $i < $quantity; $i++) {
	$time = $endingTimes[$i] - $startingTimes[$i];
	if ($time) {
		$throughput = $totals[$i] * 8 / ($time * 1024);
	} else {
		$throughput = 0;
	}
	$totalThroughput += $throughput;
	print "Throughput ($send[$i]-$recv[$i]): $throughput (kbps)\n";
}

$averageThroughput = $totalThroughput / $quantity;
print "\nAverage throughput: $averageThroughput (kbps)\n";

