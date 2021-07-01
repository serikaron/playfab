handlers.setPlayerData = function (args, context) {
    var request = {
        PlayFabId: currentPlayerId, Data: {
		[args.playerDataKey]: args.playerDataValue
            }
    };
    // The pre-defined "server" object has functions corresponding to each PlayFab server API 
    // (https://api.playfab.com/Documentation/Server). It is automatically 
    // authenticated as your title and handles all communication with 
    // the PlayFab API, so you don't have to write extra code to issue HTTP requests. 
    var result = server.UpdateUserReadOnlyData(request);
	return result;
};

handlers.getPlayerData = function (args, context) {
    var request = {
        PlayFabId: currentPlayerId, Keys: [
		args.playerDataKey
            ]
    };
    // The pre-defined "server" object has functions corresponding to each PlayFab server API 
    // (https://api.playfab.com/Documentation/Server). It is automatically 
    // authenticated as your title and handles all communication with 
    // the PlayFab API, so you don't have to write extra code to issue HTTP requests. 
    var result = server.GetUserReadOnlyData(request);
	return result;
};

