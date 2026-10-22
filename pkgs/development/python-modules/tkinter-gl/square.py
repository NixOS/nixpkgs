import tkinter
from tkinter_gl import GLCanvas
from OpenGL import GL


class SquareWidget(GLCanvas):
    profile = "legacy"

    def draw(self):
        self.make_current()
        GL.glClearColor(0, 1, 0, 1)
        GL.glClear(GL.GL_COLOR_BUFFER_BIT)
        self.swap_buffers()
        self.after(500, self.quit)


if __name__ == "__main__":
    root = tkinter.Tk()
    surface = SquareWidget(root)
    print("Using OpenGL", surface.gl_version())

    surface.pack(
        expand=True,
        fill="both",
        padx=50,
        pady=50,
    )

    root.mainloop()
