def read(x)
    File.readlines(x).each do |line|
    puts line
    end
end

def quicktime_intro()
    puts "Quick time event, use your WASD keys to play"
    sleep(1)
    puts "\nSTART"
    sleep(0.25)
end

def quicktime(desired_input,time,success_file,fail_file)
    puts "Press #{desired_input}: "
    i = 0
    while true
        
        if i < time
            action = gets.chomp
        elsif i > time
            puts "Failure"
            break
        end
        
        if action == desired_input
            read(success_file)
            @@quicktime_outcome = "win"
            break
        elsif action != desired_input
            read(fail_file)
            @@quicktime_outcome = "lose"
            break
        else
            puts "broken"
        end
        
        sleep(1)
        i += 1
        
    end
end

read('Intro.txt')
sleep(2)


class Scene
  def enter()
    puts "This scene is not yet configured. Subclass it and implement enter()."
    exit(1)
  end
end


class Cell < Scene
    def enter()
        read('Cell.txt')
        action = $stdin.gets.chomp
        if action == 'door'
            return 'hall'
        elsif action == 'window'
            return 'yard'
        else
            puts "invalid input"
            return 'cell'
        end
    end
end


class Hall < Scene
    def enter()
        read('Hall.txt')
        action = $stdin.gets.chomp
        if action == 'hall'
            return 'guard'
        elsif action == 'roof'
            return 'roof'
        else
            puts "invalid input"
            return 'hall'
        end
    end
end

class Yard < Scene
    def enter()
        read('Yard.txt')
        action = $stdin.gets.chomp
        if action == 'run'
            return 'run_1'
        elsif action == 'rush'
            read('Yard_intro.txt')
            quicktime_intro()
            quicktime("d", 2, 'Yard_sucess_1.txt', 'Yard_fail_1.txt')
            sleep(1)
            if @@quicktime_outcome == "win"
                quicktime("a", 2, 'Yard_sucess_2.txt', 'Yard_fail_2.txt')
                    if @@quicktime_outcome == "win"
                        return 'run_2'
                    end
                elsif @@quicktime_outcome == "lose"
                    return 'lose'
                else
                    puts "broken"
            end
                        
                        
        else
            puts "invalid input"
            return 'yard'
        end
    end
end

class Guard < Scene
    def enter()
        read('Guard.txt')
        action = $stdin.gets.chomp
        if action == 'hide'
            return 'armory'
        elsif action == 'rush'
            read('Hall_quicktime_intro.txt')
            quicktime_intro()
            quicktime("a", 2, 'Hall_quicktime_sucess_1.txt', 'Hall_quicktime_fail_1.txt')
            sleep(1)
                if @@quicktime_outcome == "win"
                    quicktime("s", 2, 'Hall_quicktime_sucess_2.txt', 'Hall_quicktime_fail_2.txt')
                    sleep(1)
                        if @@quicktime_outcome == "win"
                            quicktime("w", 2, 'Hall_quicktime_sucess_3.txt', 'Hall_quicktime_fail_3.txt')
                                if @@quicktime_outcome == "lose"
                                    return lose
                                end
                        elsif @@quicktime_outcome == "lose"
                            return 'lose'
                        else
                            puts "broken"
                        end
                elsif @@quicktime_outcome == "lose"
                    return 'lose'
                else
                    puts "broken"
                end
        else
            puts "invalid input"
            return 'guard'
        end
    end
end

class Armory < Scene
    def enter()
        read('Armory.txt')
        action = $stdin.gets.chomp
        if action == 'motorcycle'
            read('Motorcycle.txt')
        elsif action == 'truck'
            return 'truck'
        else
            puts "invalid input"
            return 'armory'
        end
    end
end

class Truck < Scene
    def enter()
        read('Truck_dashboard.txt')
        wires = ["red", "blue", "green", "yellow", "orange"]
        wire_1 = wires[(rand 0..4)]
        wire_2 = wires[(rand 0..4)] 
        user_1 = gets.chomp
        user_2 = gets.chomp
        
        if ((wire_1 == user_1) & (wire_2 == user_2) || (wire_2 == user_1) & (wire_1 == user_2))
            read('Truck_win.txt')
        elsif (user_1 == "back") & (user_2 == "door")
            read('Truck_win.txt')
        elsif !((wire_1 == user_1) & (wire_2 == user_2) || (wire_2 == user_1) & (wire_1 == user_2))
            read('Truck_lose.txt')
        else
            puts "broken"
        end
        
    end
end

class Run_1 < Scene
    def enter()
            read('Run_1.txt')
        action = $stdin.gets.chomp
        if action == 'sewer'
            read('Sewer.txt')
        elsif action == 'fence'
            read('Fence.txt')
        else
            puts "invalid input"
            return 'run'
        end
    end
end

class Run_2 < Scene
    def enter()
            read('Run_2.txt')
        action = $stdin.gets.chomp
        if action == 'sewer'
            read('Sewer.txt')
        elsif action == 'fence'
            read('Fence.txt')
        else
            puts "invalid input"
            return 'run'
        end
    end
end

class Roof
    def enter()
        read('Roof.txt')
        action = $stdin.gets.chomp
        if action == "parachute"
            read('Parachute.txt')
        elsif action == "climb"
            read("Climb.txt")
        else
            puts "invalid input"
            return 'roof'
        end
    end
end

class Lose
    def enter()
        puts "you lose"
    end
end
        
    
class Map
  @@scenes = {
    'cell' => Cell.new(),
    'hall' => Hall.new(),
    'guard' => Guard.new(),
    'armory' => Armory.new(),
    'truck' => Truck.new(),
    'yard' => Yard.new(),
    'run_1' => Run_1.new(),
    'run_2' => Run_2.new(),
    'roof' => Roof.new(),
    'lose' => Lose.new()
  }



  def initialize(start_scene)
    @start_scene = start_scene
  end


  def next_scene(scene_name)
    val = @@scenes[scene_name]
    return val
  end

  def opening_scene()
    return next_scene(@start_scene)
  end
end


class Engine

  def initialize(scene_map)
    @scene_map = scene_map
  end

  def play()
    current_scene = @scene_map.opening_scene()
    last_scene = @scene_map.next_scene('finished')
    while current_scene != last_scene
      next_scene_name = current_scene.enter()
      current_scene = @scene_map.next_scene(next_scene_name)
    end
    current_scene.enter()
  end
end

a_map = Map.new('cell')
a_game = Engine.new(a_map)
a_game.play()