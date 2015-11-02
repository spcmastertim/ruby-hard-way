# Built on pseudo-code from http://en.wikipedia.org/wiki/Mandelbrot_set#Computer_drawings
COLORS = %w(1;32 0;32 0;36 1;36 1;37 0;37 1;30 0;30 0;34 1;34 0;35 1;35 0;31 1;31 0;33 1;33)
NUM_COLORS = COLORS.length

# Detect terminal resolution
term_size = `stty size`.split.map { |x| x.to_i }.reverse
X_MAX = term_size[0] - 1
Y_MAX = term_size[1] - 3 # Leave room for help text at bottom

def print_color_block(color)
  color = COLORS[(color + 3) % NUM_COLORS]
  "\033[" + color + 'm' + "\xe2\x96\x88"
end

def draw_mandelbrot(zoom, center_x, center_y, max_iterations)

  output = "\n"

  (0..Y_MAX).each do |y_in_pixels_from_top_left|

    # scaled y coordinate of pixel (must be scaled to lie somewhere in the mandelbrot Y scale (-1, 1)
    y_in_pixels_from_center = y_in_pixels_from_top_left - Y_MAX.to_f / 2.0
    y_unit_range = 2.0 / zoom
    y0 = (y_unit_range * y_in_pixels_from_center / Y_MAX) - center_y

    (0..X_MAX).each do |x_in_pixels_from_top_left|

      # scaled x coordinate of pixel (must be scaled to lie somewhere in the mandelbrot X scale (-2.5 to 1)
      x_in_pixels_from_center = x_in_pixels_from_top_left - X_MAX.to_f / 2.0
      x_unit_range = 3.5 / zoom
      x0 = (x_unit_range * x_in_pixels_from_center.to_f / X_MAX) + center_x

      x, y = 0.0, 0.0
      iteration = 0

      while (x*x + y*y < 2*2 && iteration < max_iterations) do
        xtemp = x*x - y*y + x0
        y = 2*x*y + y0
        x = xtemp
        iteration = iteration + 1
      end
      output += print_color_block iteration
    end

    output += "\n"
  end

  print output
  print "\033[0m"
end

def get_keypress
  system("stty raw -echo")
  STDIN.getc.chr
ensure
  system("stty -raw echo")
end

def print_help
  puts "Move: w,a,s,d Zoom: -/+ , Reset: r, Quit: q.  Set 'Use bright colors for bold text' in Terminal."
end

# Controls precision and speed. 100 is a good balance on my 2.0GHz MBP.
iterations = 100

# Keyboard input variable. Start with a view reset
key = "r"

# Main loop
while (key != "q") do
  case key
  when '+', '='
    zoom *= 1.1
  when '-'
    zoom *= 0.9
  when "a"
    center_x -= 0.2 / zoom
  when "d"
    center_x += 0.2 / zoom
  when "w"
    center_y += 0.2 / zoom
  when "s"
    center_y -= 0.2 / zoom
  when "r"
    center_x = -0.75
    center_y = 0.0
    zoom = 1.0
  end

  draw_mandelbrot zoom, center_x, center_y, iterations
  print_help

  key = get_keypress
end
