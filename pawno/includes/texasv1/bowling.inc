Dialog:DIALOG_BOWLING(playerid,response,listitem,inputtext[])
{
	if(response)
	{
	    switch(listitem)
	    {
	        case 0:
	        {
	            if(AbleToPlay[playerid] == 1) return SendClientMessage(playerid,0xD92626AA,"You are already playing!");
	            Dialog_Show(playerid,DIALOG_ROAD, DIALOG_STYLE_LIST, "Choisir votre allée", "{00AA00}1. {FFFFFF}Allé 1 \n{00AA00}2. {FFFFFF}Allé 2 \n{00AA00}3. {FFFFFF}Allé 3 \n{00AA00}4. {FFFFFF}Allé 4 \n{00AA00}5. {FFFFFF}Allé 5  ", "Ok", "Back");
	        }
	        case 1:
	        {
	            if(AbleToPlay[playerid] == 0) return SendErrorMessage(playerid,"Aucune partie lancé de votre part!");
	            AbleToPlay[playerid] = 0;
	            BowlingRoadStatus[PlayersBowlingRoad[playerid]] = ROAD_EMPTY;
	            KillTimer(BowlingTimer[PlayersBowlingRoad[playerid]]);
	            BowlingMinutes[playerid] = 0;
	            BowlingSeconds[playerid] = 0;
	            SendServerMessage(playerid,"Vous avez mis fin a votre partie!");
				DestroyBall(playerid);
				if(PlayersBowlingScore[playerid] > PlayerData[playerid][pBestScore])
				{
					SendServerMessage(playerid,"{00CC00}Record Battu! Ancien score: {FFFFFF}%i!",PlayerData[playerid][pBestScore]);
           			SendServerMessage(playerid,"{00CC00}Nouveau score: {FFFFFF}%i!",PlayersBowlingScore[playerid]);
					PlayerData[playerid][pBestScore] = PlayersBowlingScore[playerid];
				}
				else {SendServerMessage(playerid,"{00CC00}Votre record est: {FFFFFF}%i!",PlayerData[playerid][pBestScore]);}
                PlayersBowlingScore[playerid] = 0;
	            if(PlayersBowlingRoad[playerid]==0)
	            {
					UpdateDynamic3DTextLabelText(BowlingRoadScreen[0], 0xFFFFFF,"{008800}[{FFFFFF} Allé 1{008800} ]\n Vide");
					PlayersBowlingRoad[playerid] = ROAD_NONE;
	                DestroyPins(0);
	            }
				else if(PlayersBowlingRoad[playerid]==1)
				{
					UpdateDynamic3DTextLabelText(BowlingRoadScreen[1], 0xFFFFFF,"{008800}[{FFFFFF} Allé 2{008800} ]\n Vide");
					PlayersBowlingRoad[playerid] = ROAD_NONE;
					DestroyPins(1);
				}
				else if(PlayersBowlingRoad[playerid]==2)
				{
					UpdateDynamic3DTextLabelText(BowlingRoadScreen[2], 0xFFFFFF,"{008800}[{FFFFFF} Allé 3{008800} ]\n Vide");
					PlayersBowlingRoad[playerid] = ROAD_NONE;
					DestroyPins(2);
                   }
				else if(PlayersBowlingRoad[playerid]==3)
                {
					UpdateDynamic3DTextLabelText(BowlingRoadScreen[3], 0xFFFFFF,"{008800}[{FFFFFF} Allé 4{008800} ]\n Vide");
					PlayersBowlingRoad[playerid] = ROAD_NONE;
					DestroyPins(3);
                }
				else if(PlayersBowlingRoad[playerid]==4)
				{
					UpdateDynamic3DTextLabelText(BowlingRoadScreen[4], 0xFFFFFF,"{008800}[{FFFFFF} Allé 5{008800} ]\n Vide");
					PlayersBowlingRoad[playerid] = ROAD_NONE;
					DestroyPins(4);
				}
                return 1;
            }
            case 2:
            {
                if(AbleToPlay[playerid] == 0) return SendClientMessage(playerid,0xD92626AA,"You didn't start game yet!");
                Dialog_Show(playerid,DIALOG_ADD_TIME, DIALOG_STYLE_LIST, "Ajouté du temps","{00AA00}+3 {FFFFFF}minutes {00AA00} 30$ \n{00AA00}+5 {FFFFFF}minutes {00AA00} 50$ \n{00AA00}+10 {FFFFFF}minutes{00AA00} 100$ \n{00AA00}+25 {FFFFFF}minutes{00AA00} 250$ \n{00AA00}+30 {FFFFFF}minutes{00AA00} 300$ ","Ok","Back");
            }
        }
    }
	return 1;
}
Dialog:DIALOG_ROAD(playerid,response,listitem,inputtext[])
{
   	if(response)
    {
        switch(listitem)
        {
            case 0:
            {
                if(BowlingRoadStatus[0] == ROAD_EMPTY)
                {
					PlayersBowlingRoad[playerid] = 0;
					Dialog_Show(playerid,DIALOG_BOWLING_TIME, DIALOG_STYLE_LIST, "Temps","{BBBB00}3 {FFFFFF}minutes {00AA00} 30$ \n{BBBB00}5 {FFFFFF}minutes {00AA00} 50$ \n{BBBB00}10 {FFFFFF}minutes{00AA00} 100$ \n{BBBB00}25 {FFFFFF}minutes{00AA00} 250$ \n{BBBB00}30 {FFFFFF}minutes{00AA00} 300$ ","Ok","Back");
				}
				else if(BowlingRoadStatus[0] == ROAD_BUSY) return SendErrorMessage(playerid,"Allé occupé");
			}
			case 1:
            {
                if(BowlingRoadStatus[1] == ROAD_EMPTY)
				{
				    PlayersBowlingRoad[playerid] = 1;
					Dialog_Show(playerid,DIALOG_BOWLING_TIME, DIALOG_STYLE_LIST, "Temps","{BBBB00}3 {FFFFFF}minutes {00AA00} 30$ \n{BBBB00}5 {FFFFFF}minutes {00AA00} 50$ \n{BBBB00}10 {FFFFFF}minutes{00AA00} 100$ \n{BBBB00}25 {FFFFFF}minutes{00AA00} 250$ \n{BBBB00}30 {FFFFFF}minutes{00AA00} 300$ ","Ok","Back");
				}
				else if(BowlingRoadStatus[1] == ROAD_BUSY) return SendErrorMessage(playerid,"Allé occupé");
			}
			case 2:
            {
                if(BowlingRoadStatus[2] == ROAD_EMPTY)
                {
					PlayersBowlingRoad[playerid] = 2;
					Dialog_Show(playerid,DIALOG_BOWLING_TIME, DIALOG_STYLE_LIST, "Temps","{BBBB00}3 {FFFFFF}minutes {00AA00} 30$ \n{BBBB00}5 {FFFFFF}minutes {00AA00} 50$ \n{BBBB00}10 {FFFFFF}minutes{00AA00} 100$ \n{BBBB00}25 {FFFFFF}minutes{00AA00} 250$ \n{BBBB00}30 {FFFFFF}minutes{00AA00} 300$ ","Ok","Back");
				}
				else if(BowlingRoadStatus[2] == ROAD_BUSY) return SendErrorMessage(playerid,"Allé occupé");
			}
			case 3:
            {
                if(BowlingRoadStatus[3] == ROAD_EMPTY)
                {
					PlayersBowlingRoad[playerid] = 3;
					Dialog_Show(playerid,DIALOG_BOWLING_TIME, DIALOG_STYLE_LIST, "Temps","{BBBB00}3 {FFFFFF}minutes {00AA00} 30$ \n{BBBB00}5 {FFFFFF}minutes {00AA00} 50$ \n{BBBB00}10 {FFFFFF}minutes{00AA00} 100$ \n{BBBB00}25 {FFFFFF}minutes{00AA00} 250$ \n{BBBB00}30 {FFFFFF}minutes{00AA00} 300$ ","Ok","Back");
				}
				else if(BowlingRoadStatus[3] == ROAD_BUSY) return SendErrorMessage(playerid,"Allé occupé");
			}
			case 4:
            {
                if(BowlingRoadStatus[4] == ROAD_EMPTY)
                {
					PlayersBowlingRoad[playerid] = 4;
					Dialog_Show(playerid,DIALOG_BOWLING_TIME, DIALOG_STYLE_LIST, "Temps","{BBBB00}3 {FFFFFF}minutes {00AA00} 30$ \n{BBBB00}5 {FFFFFF}minutes {00AA00} 50$ \n{BBBB00}10 {FFFFFF}minutes{00AA00} 100$ \n{BBBB00}25 {FFFFFF}minutes{00AA00} 250$ \n{BBBB00}30 {FFFFFF}minutes{00AA00} 300$","Ok","Back");
				}
				else if(BowlingRoadStatus[4] == ROAD_BUSY) return SendErrorMessage(playerid,"Road busy.");
			}
		}
	}
	else if(!response)
	{
 		PlayersBowlingRoad[playerid] = ROAD_NONE;
		Dialog_Show(playerid,DIALOG_BOWLING, DIALOG_STYLE_LIST, "Bowling", "{00AA00}1. {FFFFFF}Prendre une allé \n{00AA00}2. {FFFFFF}Fin de votre partie \n{00AA00}3. {FFFFFF}Ajouter du temps", "Ok", "Fermer");
	}
	return 1;
}
Dialog:DIALOG_BOWLING_TIME(playerid,response,listitem,inputtext[])
{
	if(response)
    {
        switch(listitem)
        {
			case 0:
			{
				GameTextForPlayer(playerid,"~y~+3 ~w~minutes",3000,1);
				BowlingMinutes[playerid] += 3;
				GiveMoney(playerid,-30);
				new moneyentrepriseid;
				argent_entreprise[moneyentrepriseid][argentmafiazone1] += 30;
				moneyentreprisesave(moneyentrepriseid);
        	}
        	case 1:
        	{
        	    GameTextForPlayer(playerid,"~y~+5 ~w~minutes",3000,1);
        	    BowlingMinutes[playerid] += 5;
        	    GiveMoney(playerid,-50);
				new moneyentrepriseid;
				argent_entreprise[moneyentrepriseid][argentmafiazone1] += 50;
				moneyentreprisesave(moneyentrepriseid);
        	}
        	case 2:
        	{
        	    GameTextForPlayer(playerid,"~y~+10 ~w~minutes",3000,1);
        	    BowlingMinutes[playerid] += 10;
        	    GiveMoney(playerid,-100);
				new moneyentrepriseid;
				argent_entreprise[moneyentrepriseid][argentmafiazone1] += 100;
				moneyentreprisesave(moneyentrepriseid);
        	}
        	case 3:
        	{
        	    GameTextForPlayer(playerid,"~y~+25 ~w~minutes",3000,1);
        	    BowlingMinutes[playerid] += 25;
        	    GiveMoney(playerid,-250);
				new moneyentrepriseid;
				argent_entreprise[moneyentrepriseid][argentmafiazone1] += 250;
				moneyentreprisesave(moneyentrepriseid);
        	}
        	case 4:
        	{
        	    GameTextForPlayer(playerid,"~y~+30 ~w~minutes",3000,1);
        	    BowlingMinutes[playerid] += 30;
        	    GiveMoney(playerid,-300);
				new moneyentrepriseid;
				argent_entreprise[moneyentrepriseid][argentmafiazone1] += 300;
				moneyentreprisesave(moneyentrepriseid);
        	}
		}
		new str[150];
		BowlingSeconds[playerid]=59;
		KillTimer(BowlingTimer[PlayersBowlingRoad[playerid]]);
		BowlingTimer[PlayersBowlingRoad[playerid]] = SetTimerEx("BowlingCountDown",1000,true,"d",playerid);
		CreatePins(playerid);
		if(PlayersBowlingRoad[playerid]==0)
		{
		    HelpBowlingRoadPickup[0] = CreateDynamicPickup(1239,3,-1975.0587,416.9655,2.5090);
			format(str,150,"{E32A2A}[{FFFFFF} Allé 5{E32A2A} ]\nOccupé\n{BBBB00}Joueur:{FFFFFF}%s\n{BBBB00}Temps:{FFFFFF}%02d:%02d\n{BBBB00}Points:{FFFFFF}%i",ReturnName(playerid, 0),BowlingMinutes[playerid],BowlingSeconds[playerid],PlayersBowlingScore[playerid]);
			UpdateDynamic3DTextLabelText(BowlingRoadScreen[0], 0xFFFFFF,str);
		}
		else if(PlayersBowlingRoad[playerid]==1)
		{
		    HelpBowlingRoadPickup[1] = CreateDynamicPickup(1239,3,-1975.0587,415.4035,2.5090);
			format(str,150,"{E32A2A}[{FFFFFF} Allé 5{E32A2A} ]\nOccupé\n{BBBB00}Joueur:{FFFFFF}%s\n{BBBB00}Temps:{FFFFFF}%02d:%02d\n{BBBB00}Points:{FFFFFF}%i",ReturnName(playerid, 0),BowlingMinutes[playerid],BowlingSeconds[playerid],PlayersBowlingScore[playerid]);
			UpdateDynamic3DTextLabelText(BowlingRoadScreen[1], 0xFFFFFF,str);
		}
		else if(PlayersBowlingRoad[playerid]==2)
		{
		    HelpBowlingRoadPickup[2] = CreateDynamicPickup(1239,3,-1975.0587,413.8728,2.5090);
			format(str,150,"{E32A2A}[{FFFFFF} Allé 5{E32A2A} ]\nOccupé\n{BBBB00}Joueur:{FFFFFF}%s\n{BBBB00}Temps:{FFFFFF}%02d:%02d\n{BBBB00}Points:{FFFFFF}%i",ReturnName(playerid, 0),BowlingMinutes[playerid],BowlingSeconds[playerid],PlayersBowlingScore[playerid]);
			UpdateDynamic3DTextLabelText(BowlingRoadScreen[2], 0xFFFFFF,str);
		}
		else if(PlayersBowlingRoad[playerid]==3)
		{
		    HelpBowlingRoadPickup[3] = CreateDynamicPickup(1239,3,-1975.0587,412.2807,2.5090);
			format(str,150,"{E32A2A}[{FFFFFF} Allé 5{E32A2A} ]\nOccupé\n{BBBB00}Joueur:{FFFFFF}%s\n{BBBB00}Temps:{FFFFFF}%02d:%02d\n{BBBB00}Points:{FFFFFF}%i",ReturnName(playerid, 0),BowlingMinutes[playerid],BowlingSeconds[playerid],PlayersBowlingScore[playerid]);
			UpdateDynamic3DTextLabelText(BowlingRoadScreen[3], 0xFFFFFF,str);
		}
		else if(PlayersBowlingRoad[playerid]==4)
		{
		    HelpBowlingRoadPickup[4] = CreateDynamicPickup(1239,3,-1975.0587,410.7207,2.5090);
		    format(str,150,"{E32A2A}[{FFFFFF} Allé 5{E32A2A} ]\nOccupé\n{BBBB00}Joueur:{FFFFFF}%s\n{BBBB00}Temps:{FFFFFF}%02d:%02d\n{BBBB00}Points:{FFFFFF}%i",ReturnName(playerid, 0),BowlingMinutes[playerid],BowlingSeconds[playerid],PlayersBowlingScore[playerid]);
			UpdateDynamic3DTextLabelText(BowlingRoadScreen[4], 0xFFFFFF,str);
		}
		BowlingRoadStatus[PlayersBowlingRoad[playerid]] = ROAD_BUSY;
		AbleToPlay[playerid] = 1;
		SendServerMessage(playerid,"Vous avez commencer une partie!");
		SendServerMessage(playerid,"Allez au début de l'allé et appuyer sur \"~k~~CONVERSATION_NO~\" pour lancer votre boule!");
	}
    else if(!response)
        {Dialog_Show(playerid,DIALOG_ROAD, DIALOG_STYLE_LIST, "Choisir votre allée", "{00AA00}1. {FFFFFF}Allé 1 \n{00AA00}2. {FFFFFF}Allé 2 \n{00AA00}3. {FFFFFF}Allé 3 \n{00AA00}4. {FFFFFF}Allé 4 \n{00AA00}5. {FFFFFF}Allé 5  ", "Ok", "Back");}
	return 1;
}
Dialog:DIALOG_ADD_TIME(playerid,response,listitem,inputtext[])
{
	if(response)
	{
    	switch(listitem)
	    {
        	case 0:
        	{
				GameTextForPlayer(playerid,"~y~+3 ~w~minutes",3000,1);
				BowlingMinutes[playerid] += 3;
				GiveMoney(playerid,-30);
				new moneyentrepriseid;
				argent_entreprise[moneyentrepriseid][argentmafiazone1] += 30;
				moneyentreprisesave(moneyentrepriseid);
        	}
        	case 1:
        	{
        	    GameTextForPlayer(playerid,"~y~+5 ~w~minutes",3000,1);
        	    BowlingMinutes[playerid] += 5;
        	    GiveMoney(playerid,-50);
				new moneyentrepriseid;
				argent_entreprise[moneyentrepriseid][argentmafiazone1] += 50;
				moneyentreprisesave(moneyentrepriseid);
        	}
        	case 2:
        	{
        	    GameTextForPlayer(playerid,"~y~+10 ~w~minutes",3000,1);
        	    BowlingMinutes[playerid] += 10;
        	    GiveMoney(playerid,-100);
				new moneyentrepriseid;
				argent_entreprise[moneyentrepriseid][argentmafiazone1] += 100;
				moneyentreprisesave(moneyentrepriseid);
        	}
        	case 3:
        	{
        	    GameTextForPlayer(playerid,"~y~+25 ~w~minutes",3000,1);
        	    BowlingMinutes[playerid] += 25;
        	    GiveMoney(playerid,-250);
				new moneyentrepriseid;
				argent_entreprise[moneyentrepriseid][argentmafiazone1] += 250;
				moneyentreprisesave(moneyentrepriseid);
        	}
        	case 4:
        	{
        	    GameTextForPlayer(playerid,"~y~+30 ~w~minutes",3000,1);
        	    BowlingMinutes[playerid] += 30;
        	    GiveMoney(playerid,-300);
				new moneyentrepriseid;
				argent_entreprise[moneyentrepriseid][argentmafiazone1] += 300;
				moneyentreprisesave(moneyentrepriseid);
        	}
		}
		new str[128];
		KillTimer(BowlingTimer[PlayersBowlingRoad[playerid]]);
		BowlingTimer[PlayersBowlingRoad[playerid]] = SetTimerEx("BowlingCountDown",1000,true,"d",playerid);
		format(str,128,"{E32A2A}[{FFFFFF} Allé 5{E32A2A} ]\n Occupé \n {BBBB00}Joueur: {FFFFFF}%s\n {BBBB00} Temps:{FFFFFF} %02d:%02d ",ReturnName(playerid, 0),BowlingMinutes[playerid],BowlingSeconds[playerid]);
		UpdateDynamic3DTextLabelText(BowlingRoadScreen[PlayersBowlingRoad[playerid]], 0xFFFFFF,str);
	}
	else if(!response)
	{
		Dialog_Show(playerid,DIALOG_BOWLING, DIALOG_STYLE_LIST, "Bowling", "{00AA00}1. {FFFFFF}Prendre une allé \n{00AA00}2. {FFFFFF}Fin de votre partie \n{00AA00}3. {FFFFFF}Ajouter du temps", "Ok", "Fermer");
	}
	return 1;
}