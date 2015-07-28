#!/usr/bin/ruby

w = h = 500

funcs = {
    'simple' => {
        r: ->x, y{ (x+y).to_f / (w+h) * 255 },
        g: ->x, y{ x.to_f / w * 255 },
        b: ->x, y{ y.to_f / h * 255 }
    },
    'trig' => {
        b: ->x, y{ (Math.sin((x+y).to_f / (w+h)) + 1) / 2 * 255 },
        r: ->x, y{ (Math.sin(x.to_f / w) + 1) / 2 * 255 },
        g: ->x, y{ (Math.sin(y.to_f / h) + 1) / 2 * 255 }
    },
    'pythag' => {
        r: ->x, y{ ((w/2-x.to_f)**2 + (h/2-y.to_f)**2) / (((w/2)**2) + ((h/2)**2)) * 255 },
        g: ->x, y{ ((w/2-(x*2%w).to_f)**2 + (h/2-y.to_f)**2) / (((w/2)**2) + ((h/2)**2)) * 255 },
        b: ->x, y{ ((w/2-x.to_f)**2 + (h/2-(y*2%h).to_f)**2) / (((w/2)**2) + ((h/2)**2)) * 255 },
    }
}

if funcs[ARGV[0]]
    funcs = funcs[ARGV[0]]
else
    STDERR.puts 'Usage: ./colors.rb [FUNCTION]'
    STDERR.puts "Unknown function #{ARGV[0]}" if ARGV[0]
    STDERR.puts "Valid functions: #{funcs.keys.join ', '}"
    exit
end

File.open('out.ppm', 'w') do |f|
    f.puts "P3 #{w} #{h} 255"
    0.upto w do |x|
        0.upto h do |y|
            f.puts "#{funcs[:r][x,y].to_i} #{funcs[:g][x,y].to_i} " +
                "#{funcs[:b][x,y].to_i}"
        end
    end
end

`convert out.ppm #{ARGV[0]}.png`
File.delete 'out.ppm'
