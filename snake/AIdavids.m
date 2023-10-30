function direction = AIdavids( map,pos, directionIn )
    if directionIn == 0  
        direction = randi([1,4]);
    else
        direction = directionIn;
    end
    
    smery = [0,-1,1];
    smery(2:3) = smery(randperm(2)+1);
    hodnoty = [];
    for s = smery
        novy_s = zatoc(direction, s);
        pos_next = pos + smer(novy_s);
        hodnoty = [hodnoty, ohodnot(map, pos_next, novy_s, smery)];
    end
    [m id] = max(hodnoty);
    s = smery(id);
    direction = zatoc(direction, s);
end

function novy_smer = zatoc(smer, kam)
    novy_smer = mod((smer + kam - 1),4)+1;
end

function value = ohodnot(map, pos, s, smery)
    if (volno(map, pos))
       value = 1;
       value = value + kolik_je_ve_smeru_dobra(map, pos, s, smery);
    elseif (jidlo(map, pos))
       if (nabouram_v_budoucnu(map, pos, smery, s))
            value = -6000;
       elseif (je_slepa(map, pos, s, smery, true))
            value = -5000;
       else
            value = 10000;
       end
    else    
        value = -10000;
    end
end

function out = kolik_je_ve_smeru_dobra(map, pos, s, smery)
    out = 0;
    start_pos = pos;
    jak_moc_zalezi = 0;
    if (nabouram_v_budoucnu(map, pos, smery, s))
        out = -5000;
        return
    end
    for x = 1:30
        if (jidlo(map, start_pos))
            out = out + 500 + jak_moc_zalezi;
        elseif (volno(map, start_pos))
            out = out + 1;
        else
            if (je_slepa(map, start_pos - smer(s), s, smery, false))
               out = -5000; 
            end
            break;
        end
        start_pos = start_pos + smer(s);
        jak_moc_zalezi = jak_moc_zalezi - 10;
    end
end

function out = volno(map, pos)
    if (map(pos(1), pos(2)) == 0)
        out = true;
    else
        out = false;
    end
end

function out = jidlo(map, pos)
    if (map(pos(1), pos(2)) == 2)
        out = true;
    else
        out = false;
    end
end

function out = je_slepa(map, pos, s, smery, bereme_jidlo)
     zbyle_smery = smery(smery~=s);
    if (bereme_jidlo)
         zbyle_smery = smery;
    end
    for s1 = zbyle_smery
        novy_s = zatoc(s, s1);
        pos_next = pos + smer(novy_s);
            if (jidlo(map, pos_next) || volno(map, pos_next))
                out = false;
                return
            end
    end
    out = true;
end

function out = nabouram_v_budoucnu(map, pos, smery, s)
    for s1 = smery
    novy_s = zatoc(s, s1);
    pos_next = pos + smer(novy_s);
        if hlava(map, pos_next)
            out = true;
            return
        end
    end
    out = false;
end

function out = hlava(map, pos)
    if (map(pos(1), pos(2)) >= 200)
        out = true;
    else
        out = false;
    end
end

function value = smer(id)
    smery = [-1,0;0,1;1,0;0,-1];
    value = smery(id,:);
end