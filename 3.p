set title 'Throughput vs sim time of 5 first connections'
set xlabel 'Simulation Time (s)'
set ylabel 'Throughput(t) (kbps)'
plot 'out-0.tr' w lines,'out-1.tr' w lines, 'out-2.tr' w lines, 'out-3.tr' w lines, 'out-4.tr' w lines
