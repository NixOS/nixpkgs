import emerge as em

mm = 0.001  # Define a millimeter
wg_width = 22.86 * mm  # Width of WR90 waveguide
wg_height = 10.16 * mm  # Height of WR90 waveguide
wg_length = 50 * mm  # Arbitrary length

model = em.Simulation("MyFirstModel")

box = em.geo.Box(wg_width, wg_length, wg_height)

model.commit_geometry()

model.view(screenshot="001-01.png", off_screen=True)

model.mw.set_frequency_range(8e9, 10e9, 21)

model.generate_mesh()

model.view(plot_mesh=True, screenshot="001-02.png", off_screen=True)

port1 = model.mw.bc.RectangularWaveguide(box.front, 1)
port2 = model.mw.bc.RectangularWaveguide(box.back, 2)

fdata = model.mw.run_sweep()

freqs = fdata.scalar.grid.freq
S11 = fdata.scalar.grid.S(1, 1)
S21 = fdata.scalar.grid.S(2, 1)

from emerge.plot import plot_sp

plot_sp(
    freqs,
    [S11, S21],
    labels=["S11", "S21"],
    dblim=[-60, 3],
    show_plot=False,
    filename="001-03.png",
)
