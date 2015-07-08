rename("im1");
waitForUser("bla");
run("Mask Of Nearby Points", "add=3.0000 ...=128");
run("Set Measurements...", "centroid redirect=None decimal=3");
run("Analyze Particles...", "  show=Nothing display")
print(nResults);
selectWindow("im1");
for (i=0;i<1;i++)
{
        makePoint(getResult("X",i), getResult("Y",i));
}
run("Level Sets", "method=[Active Contours] use_fast_marching use_level_sets grey_value_threshold=50 distance_threshold=0.50 advection=2.20 propagation=1 curvature=1 grayscale=30 convergence=0.0050 region=outside");
