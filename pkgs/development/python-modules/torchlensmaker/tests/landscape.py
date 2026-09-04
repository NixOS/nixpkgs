import torchlensmaker as tlm

optics = tlm.Sequential(
    tlm.ObjectAtInfinity(beam_diameter=10, angular_size=20),
    tlm.Gap(15),
    tlm.RefractiveSurface(
        tlm.SphereByCurvature(diameter=25, C=1 / -45.0), materials=("air", "BK7")
    ),
    tlm.Gap(3),
    tlm.RefractiveSurface(
        tlm.SphereByCurvature(diameter=25, C=tlm.parameter(1 / -20)),
        materials=("BK7", "air"),
    ),
    tlm.Gap(100),
    tlm.ImagePlane(50),
)

tlm.simple_optimize(optics, tlm.optim.Adam(optics.parameters(), lr=5e-4), 100)

tlm.show2d(optics, title="Landscape Lens")
tlm.export_json(optics, "landscape.json", dim=2, title="Landscape Lens")
