class Maze

  attr_reader :rows
  attr_reader :columns
  attr_reader :data    #store all content(cells and walls)
  attr_reader :traces  #store steps for width-first algorithm
  attr_reader :res  #store steps for final result

  def initialize(n, m)
    @rows = n
    @columns = m
    @data = Array.new(2*n+1)
    @traces = Array.new()
    @res = Array.new()
  end
  
  def load(arg)
    i = 0
    rnum = @rows*2+1
    cnum = @columns*2+1
    while i<rnum do 
      @data[i] = Array.new(cnum)
      j = 0
      while j<cnum do
        @data[i][j] = arg[i*cnum+j]<=>'0'
        j+=1
      end
      i+=1
    end
  end

  def display
    i = 0
    rnum = @rows*2+1
    cnum = @columns*2+1
    while i<rnum do 
      j = 0
      while j<cnum do
        if @data[i][j]==1
          print "+"
        else
          print " "
        end
      j+=1
      end
      print "\n"
      i+=1
    end
  end
  
  def solve(begX, begY, endX, endY)
    i=0
    @traces.push([begX, begY])
    result=false
    while i<@traces.length do
      tempX=@traces[i][0]
      tempY=@traces[i][1]
      if @data[tempX*2][tempY*2+1]==0      #up wall not exist
        if (tempX-1)==endX and tempY==endY
          result=true
          break
        end  
        if !@traces.include?([tempX-1, tempY])
          @traces.push([tempX-1, tempY])
        end
      end
      if @data[tempX*2+1][tempY*2]==0      #left wall not exist
        if tempX==endX and (tempY-1)==endY
          result=true
          break
        end 
        if !@traces.include?([tempX, tempY-1])
          @traces.push([tempX, tempY-1])
        end
      end
      if @data[tempX*2+2][tempY*2+1]==0      #down wall not exist
        if (tempX+1)==endX and tempY==endY
          result=true
          break
        end 
        if !@traces.include?([tempX+1, tempY])
          @traces.push([tempX+1, tempY])
        end
      end
      if @data[tempX*2+1][tempY*2+2]==0      #right wall not exist
        if tempX==endX and (tempY+1)==endY
          result=true
          break
        end 
        if !@traces.include?([tempX, tempY+1])
          @traces.push([tempX, tempY+1])
        end
      end
      i+=1
    end
    if result                   #delete unused cells
      @traces.slice!(i+1)
    end
    return result
  end
  
  def trace(begX, begY, endX, endY)    #before use this, make sure the solve return true
    @res.push([endX, endY])
    temp=@traces.pop
    @res.push(temp)
    while temp do
      if t=@traces.pop
        if connect(temp[0], temp[1], t[0], t[1])
          temp=t
          @res.push(temp)
        end
      else 
        break
      end
    end
    while rr=@res.pop do
      puts "(#{rr[0]},#{rr[1]})"
    end
  end
  
  def connect(firstX, firstY, secondX, secondY)
    if firstX==secondX+1 and firstY==secondY and @data[firstX*2][firstY*2+1]==0      #up
      return true
    elsif firstX==secondX and firstY==secondY+1 and @data[firstX*2+1][firstY*2]==0      #left
      return true
    elsif firstX==secondX-1 and firstY==secondY and @data[firstX*2+2][firstY*2+1]==0      #down
      return true
    elsif firstX==secondX and firstY==secondY-1 and @data[firstX*2+1][firstY*2+2]==0      #right
      return true
    else
      return false
    end
  end
  
  def redesign
    rnum = @rows*2+1
    cnum = @columns*2+1
    i=1
    while i<rnum do                #change the left and right walls of the cells(except the bound)
      j = 2
      while j<cnum-1 do
        if Random.rand(10)<5
          @data[i][j]=0
        else
          @data[i][j]=1
        end
      j+=2
      end
      i+=2
    end
    i=2
    while i<rnum-1 do                #change the up and down walls of the cells(except the bound)
      j = 1
      while j<cnum do
        if Random.rand(10)<5
          @data[i][j]=0
        else
          @data[i][j]=1
        end
      j+=2
      end
      i+=2
    end
  end
  
end


mz_f=Maze.new(2,3)
mz_f.load("11111111000001101010110001011111111")
mz_f.display
puts mz_f.solve(0,0,1,2)
mz_f.trace(0,0,1,2)
mz_f.redesign
mz_f.display
puts mz_f.solve(0,0,1,2)

mz_s=Maze.new(2,3)
mz_s.load("11111111000001101010110000011111111")
mz_s.display
puts mz_s.solve(0,0,1,2)
mz_s.trace(0,0,1,2)
mz_s.redesign
mz_s.display
puts mz_s.solve(0,0,1,2)
