Function RunScreenSaver( params As Object ) As Object
    Main()
End Function

sub Main()
    print "in showChannelSGScreen"
    screen = CreateObject("roSGScreen")
    print "Created SGScreen ";screen

    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)

    newID = "global"+Stri( Rnd(10000) )
    print "New ID should be ";newID

    glb = screen.getGlobalNode()
    glb.id = newID
    
    glb.AddField("train1", "string", true)
    glb.train1 = ""
    glb.observeField("train1", m.port)

    glb.AddField("train2", "string", true)
    glb.train2 = ""
    glb.observeField("train2", m.port)

    glb.AddField("train3", "string", true)
    glb.train3 = ""
    glb.observeField("train3", m.port)

    glb.AddField("train4", "string", true)
    glb.train4 = ""
    glb.observeField("train4", m.port)

    glb.AddField("train5", "string", true)
    glb.train5 = ""
    glb.observeField("train5", m.port)

    glb.AddField("train6", "string", true)
    glb.train6 = ""
    glb.observeField("train6", m.port)

    print "Global in Screen ";glb
    print "Local global ";m.global

    scene = screen.CreateScene("MetroScene")
    screen.show()


    while(true)
        trains = getTrains()
        processTrains(trains, glb)
        sleep(2000)

    end while
end sub

Function processTrains(trains,glb) as void
    if (not (trains[0] = invalid))
        curr = trains[0]
        color = getColor(curr)
        glb.train1 = formatTrain(curr)
    end if
    if (not (trains[1] = invalid))
        curr = trains[1]
        color = getColor(curr)
        glb.train2 = formatTrain(curr)
    end if
    if (not (trains[2] = invalid))
        curr = trains[2]
        color = getColor(curr)
        glb.train3 = formatTrain(curr)
    end if
    if (not (trains[3] = invalid))
        curr = trains[3]
        color = getColor(curr)
        glb.train4 = formatTrain(curr)
    end if
    if (not (trains[4] = invalid))
        curr = trains[4]
        color = getColor(curr)
        glb.train5 = formatTrain(curr)
    end if
    if (not (trains[5] = invalid))
        curr = trains[5]
        color = getColor(curr)
        glb.train6 = formatTrain(curr)
    end if
end Function

Function formatTrain(train) as string
    ret = train.Line + "    " + train.Car + "    " + train.DestinationName
    num = len(train.DestinationName)
    while (num < 15)
        ret = ret + " "
        num = num + 1
    end while
    num = len(train.Min)
    if (num = 1)
        ret = ret + "  "
    end if
    if (num = 2)
        ret = ret + " "
    end if

    ret = ret + train.Min
    return ret 
    
end Function

Function getColor(train) as string
    line = train.Line
    if (line = "GR")
        return "<Green>GR</Green>"
    end if
    if (line = "RD")
        return "<Red>RD</Red>"
    end if
    if (line = "BL")
        return "<Blue>BL</Blue>"
    end if
    if (line = "SV")
        return "<Silver>SV</Silver>"
    end if
    if (line = "YL")
        return "<Yellow>YL</Yellow>"
    end if
    if (line = "OR")
        return "<Orange>OR</Orange>"
    end if
end Function

Function getTrains() as object
    request = CreateObject("roUrlTransfer")
    port = CreateObject("roMessagePort")
    request.SetMessagePort(port)
    request.SetUrl("https://api.wmata.com/StationPrediction.svc/json/GetPrediction/E03")
    request.AddHeader("api_key", "76213e04303043e289735cd0f13eb6f7")
    request.AddHeader("Host", "api.wmata.com")
    
    request.SetCertificatesFile("common:/certs/ca-bundle.crt")
    request.AddHeader("X-Roku-Reserved-Dev-Id", "")
    request.InitClientCertificates()
    

    if (request.AsyncGetToString())
        while (true)
            msg = wait(1000, port)
            if (type(msg) = "roUrlEvent")
                code = msg.GetResponseCode()
                if (code = 200)
                    json = ParseJSON(msg.GetString())
                    return json.Trains
                else
                    request.AsyncCancel()
                    return "ddd"
                endif
            else 
                request.AsyncCancel()
                return "cccc"
            endif
        end while
    endif
    return invalid
End Function
