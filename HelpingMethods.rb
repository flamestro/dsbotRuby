require_relative 'Spielbrett'

$width_height = 6
#spalte die fen Notation in eine Collection mit 
#den stapeln inklusive leere Stapel
def splitFen(fenNot)
    count=0
    result =Array.new
	fields = (fenNot+",").gsub('/',',').gsub(',,',', ,').split(",")
    fields.each do |value| 
        if value== " "
            result[count] = ""
        else 
            result[count] = value
        end
    count += 1
    end
    result
end

#splits a complete fen in to a List of [0]=> fen [1]=>player
def splitCompleteFen(input)
    splitedList = input.split(" ")
end

#converts splitedFen into a GameStackList
def createGameStackList(inputFen)
    inputFen    = splitFen(inputFen)
    count       = 0
    outputList  = Array.new
    while count < inputFen.length
        outputList[count] = GameStack.new(inputFen[count],count)
        count +=1
    end
    outputList
end

def reflect(distance,count)
    if count%2 == 0
    distance
    else
    $width_height-distance-1
    end
end

def getPossiblePos(pos,schritte)
    count = 0
    distance = pos+ schritte
    while (distance-1)>($width_height-1)
        count +=1
        distance-=($width_height-1)
    end
    reflect(distance-1, count)+1
end

def getPossibleNeg(pos,schritte)
    count = 0
    distance = pos-schritte
    while (distance-1)<0
        count +=1
        distance+=($width_height-1)
    end
    reflect(distance-1, count)+1
end

def checkTooTallExists(gameStack,playerOnTurn)
    result = false 
    cntTooTall = 0
    while cntTooTall< gameStack.length
     if  gameStack[cntTooTall].value > 4 && gameStack[cntTooTall].ownedBy == playerOnTurn
       result = true
     end
     cntTooTall+=1
    end
    result
end
def calculateMoves(gameStack,playerOnTurn)
    listOfMoves = Array.new
    cnt = 0 
    i   = 0
    
   
    tooTallExists = checkTooTallExists(gameStack,playerOnTurn)
  
    while i< gameStack.length && tooTallExists == true
    if  gameStack[i].ownedBy == playerOnTurn &&gameStack[i].value > 4
    count = gameStack[i].value.dup
      
    while gameStack[i].value-count < 5
        listOfMoves[cnt]   = Move.new(FieldPos.new(gameStack[i].zeile,gameStack[i].spalte), count, FieldPos.new(gameStack[i].zeile,getPossiblePos(gameStack[i].spalte,count)))
        listOfMoves[cnt+1] = Move.new(FieldPos.new(gameStack[i].zeile,gameStack[i].spalte), count, FieldPos.new(gameStack[i].zeile,getPossibleNeg(gameStack[i].spalte,count)))
        listOfMoves[cnt+2] = Move.new(FieldPos.new(gameStack[i].zeile,gameStack[i].spalte), count, FieldPos.new(getPossiblePos(gameStack[i].zeile,count),gameStack[i].spalte))
        listOfMoves[cnt+3] = Move.new(FieldPos.new(gameStack[i].zeile,gameStack[i].spalte), count, FieldPos.new(getPossibleNeg(gameStack[i].zeile,count),gameStack[i].spalte))
        listOfMoves[cnt+4] = Move.new(FieldPos.new(gameStack[i].zeile,gameStack[i].spalte), count, FieldPos.new(getPossiblePos(gameStack[i].zeile,count),getPossiblePos(gameStack[i].spalte,count)))
        listOfMoves[cnt+5] = Move.new(FieldPos.new(gameStack[i].zeile,gameStack[i].spalte), count, FieldPos.new(getPossibleNeg(gameStack[i].zeile,count),getPossiblePos(gameStack[i].spalte,count)))
        listOfMoves[cnt+6] = Move.new(FieldPos.new(gameStack[i].zeile,gameStack[i].spalte), count, FieldPos.new(getPossiblePos(gameStack[i].zeile,count),getPossibleNeg(gameStack[i].spalte,count)))
        listOfMoves[cnt+7] = Move.new(FieldPos.new(gameStack[i].zeile,gameStack[i].spalte), count, FieldPos.new(getPossibleNeg(gameStack[i].zeile,count),getPossibleNeg(gameStack[i].spalte,count)))
        count             -= 1
        cnt               += 8
    end
    end
    i +=1
    end
    
    while i< gameStack.length && tooTallExists == false
    if  gameStack[i].ownedBy == playerOnTurn
    count = gameStack[i].value.dup
      
    while count>0
        startPos= FieldPos.new(gameStack[i].zeile,gameStack[i].spalte)
        z=0
        if(!startPos.same?(FieldPos.new(gameStack[i].zeile,getPossiblePos(gameStack[i].spalte,count))))
        listOfMoves[cnt+0] = Move.new(startPos, count, FieldPos.new(gameStack[i].zeile,getPossiblePos(gameStack[i].spalte,count)))
        z+=1
        end
        
        if(!startPos.same?(FieldPos.new(gameStack[i].zeile,getPossibleNeg(gameStack[i].spalte,count))))
        listOfMoves[cnt+1] = Move.new(startPos, count, FieldPos.new(gameStack[i].zeile,getPossibleNeg(gameStack[i].spalte,count)))
        z+=1
        end
        
        if(!startPos.same?(FieldPos.new(getPossiblePos(gameStack[i].zeile,count),gameStack[i].spalte)))
        listOfMoves[cnt+2] = Move.new(startPos, count, FieldPos.new(getPossiblePos(gameStack[i].zeile,count),gameStack[i].spalte))
        z+=1
        end
        
        if(!startPos.same?(FieldPos.new(getPossibleNeg(gameStack[i].zeile,count),gameStack[i].spalte)))
        listOfMoves[cnt+3] = Move.new(startPos, count, FieldPos.new(getPossibleNeg(gameStack[i].zeile,count),gameStack[i].spalte))
        z+=1
        end
        
        if(!startPos.same?( FieldPos.new(getPossiblePos(gameStack[i].zeile,count),getPossiblePos(gameStack[i].spalte,count))))
        listOfMoves[cnt+4] = Move.new(startPos, count, FieldPos.new(getPossiblePos(gameStack[i].zeile,count),getPossiblePos(gameStack[i].spalte,count)))
        z+=1
        end
        
        if(!startPos.same?(FieldPos.new(getPossibleNeg(gameStack[i].zeile,count),getPossiblePos(gameStack[i].spalte,count))))
        listOfMoves[cnt+5] = Move.new(startPos, count, FieldPos.new(getPossibleNeg(gameStack[i].zeile,count),getPossiblePos(gameStack[i].spalte,count)))
        z+=1
        end
        
        if(!startPos.same?(FieldPos.new(getPossiblePos(gameStack[i].zeile,count),getPossibleNeg(gameStack[i].spalte,count))))
        listOfMoves[cnt+6] = Move.new(startPos, count, FieldPos.new(getPossiblePos(gameStack[i].zeile,count),getPossibleNeg(gameStack[i].spalte,count)))
        z+=1
        end
        
        if(!startPos.same?(FieldPos.new(getPossibleNeg(gameStack[i].zeile,count),getPossibleNeg(gameStack[i].spalte,count))))
        listOfMoves[cnt+7] = Move.new(startPos, count, FieldPos.new(getPossibleNeg(gameStack[i].zeile,count),getPossibleNeg(gameStack[i].spalte,count)))
        z+=1
        end
        count             -= 1
        cnt               += z+1
    end
    end
    i +=1
    end
   
    listOfMoves
end

def uniqMoves(moves)
    seen = Array.new
    cnt_m = 0
    cnt_s = 0
    cnt_addedS = 0
    addToSeen = true
    while cnt_m < moves.length
        moves[cnt_m]
        while cnt_s < seen.length && addToSeen==true
           addToSeen = moves[cnt_m].same?(seen[cnt_s])
           cnt_s +=1
        end
        if addToSeen
            seen[cnt_addedS] = moves[cnt_m]
            cnt_addedS+=1
        end
        
        addToSeen = true
        cnt_m+=1
    end
    
    seen
end

def listMoves(completeFen) 
	fen           = splitCompleteFen(completeFen)[0]
    player        = splitCompleteFen(completeFen)[1]
    gameStacklist = createGameStackList(fen)
    moves         = calculateMoves(gameStacklist,player)
    moves.delete(nil)
    clearedMoves  = uniqMoves(moves)
    
    movesString   = ""
    print "["
    clearedMoves.each do |move|
    if(move.to_s!="")
    movesString += move.to_s+","#
    end
    end
    print movesString[0,movesString.length-1]
    print "]\n"+clearedMoves.length.to_s
end
