#!/usr/bin/perl

@send;
@recv;
$quantity = 0;
@sPkgQuantities;
@rPkgQuantities;

open(DATA, '04traffic-seed0.97.txt') or die "couldn't open file 04traffic-seed0.97.txt, $!";

while (<DATA>) {
	@x = split(' ');
	if ($x[2] eq 'connecting') {
		$send[$quantity] = $x[1];
		$recv[$quantity] = $x[4];
		$sPkgQuantities[$quantity] = 0;
		$rPkgQuantities[$quantity] = 0;
		$quantity++;
	}
}
close(DATA);

open(DATA, 'wireless1-out.tr') or die "couldn't open file wireless1-out.tr, $!";
while (<DATA>) {
	@x = split(/[' ','\[','\]',':']+/);
	if ($x[3] eq 'AGT') {
		if ($x[6] eq 'tcp') {
			$tmpsend = $x[13];
			$tmprecv = $x[15];
			for ($i = 0; $i < $quantity; $i++) {
				if (($tmpsend eq $send[$i]) && ($tmprecv eq $recv[$i])) {
					if ($x[0] eq 's') {
						$sPkgQuantities[$i]++;
						last;
					}
					if ($x[0] eq 'r') {
						$rPkgQuantities[$i]++;
						last;
					}
				}
			}
		} elsif ($x[6] eq 'ack') {
			$tmpsend = $x[15];
			$tmprecv = $x[13];
			for ($i = 0; $i < $quantity; $i++) {
				if (($tmpsend eq $send[$i]) && ($tmprecv eq $recv[$i])) {
					if ($x[0] eq 's') {
						$sPkgQuantities[$i]++;
						last;
					}
					if ($x[0] eq 'r') {
						$rPkgQuantities[$i]++;
						last;
					}
				}
			}
		}
	} 
}
close(DATA);

$totalPDR = 0;
for ($i = 0; $i < $quantity; $i++){
	$pdr = $rPkgQuantities[$i] / $sPkgQuantities[$i];
	$totalPDR += $pdr;
	print "PDR ($send[$i]-$recv[$i]): $pdr\n";
}

$avrgPDR = $totalPDR / $quantity;
print "\nAverage PDR: $avrgPDR\n";

