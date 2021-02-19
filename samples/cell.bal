import ballerinax/googleapis_sheets as sheets;
import ballerina/config;
import ballerina/log;

sheets:SpreadsheetConfiguration config = {
    oauth2Config: {
        accessToken: "<Access token here>",
        refreshConfig: {
            clientId: config:getAsString("CLIENT_ID"),
            clientSecret: config:getAsString("CLIENT_SECRET"),
            refreshUrl: config:getAsString("REFRESH_URL"),
            refreshToken: config:getAsString("REFRESH_TOKEN")
        }
    }
};

sheets:Client spreadsheetClient = new (config);

public function main() {
    string spreadsheetId = "";
    string sheetName = "";

    // Create Spreadsheet with given name
    sheets:Spreadsheet|error response = spreadsheetClient->createSpreadsheet("NewSpreadsheet");
    if (response is sheets:Spreadsheet) {
        log:print("Spreadsheet Details: " + response.toString());
        spreadsheetId = response.spreadsheetId;
    } else {
        log:printError("Error: " + response.toString());
    }

    // Add a New Worksheet with given name to the Spreadsheet with the given Spreadsheet ID 
    sheets:Sheet|error sheet = spreadsheetClient->addSheet(spreadsheetId, "NewWorksheet");
    if (sheet is sheets:Sheet) {
        log:print("Sheet Details: " + sheet.toString());
        sheetName = sheet.properties.title;
    } else {
        log:printError("Error: " + sheet.toString());
    }

    string a1Notation = "B2";

    // Sets the value of the given cell of the Sheet
    error? spreadsheetRes = spreadsheetClient->setCell(spreadsheetId, sheetName, a1Notation, "ModifiedValue");
    if (spreadsheetRes is ()) {
        // Gets the value of the given cell of the Sheet
        (string|int|float)|error getValuesResult = spreadsheetClient->getCell(spreadsheetId, sheetName, a1Notation);
        if (getValuesResult is (string|int|float)) {
            log:print("Cell Details: " + getValuesResult.toString());
        } else {
            log:printError("Error: " + getValuesResult.toString());
        }

        // Clears the given cell of contents, formats, and data validation rules.
        error? clear = spreadsheetClient->clearCell(spreadsheetId, sheetName, a1Notation);
        if (clear is ()) {
            (string|int|float)|error openRes = spreadsheetClient->getCell(spreadsheetId, sheetName, a1Notation);
            if (openRes is (string|int|float)) {
                log:print("Cell Details: " + openRes.toString());
            } else {
                log:printError("Error: " + openRes.toString());
            }
        } else {
            log:printError("Error: " + clear.toString());
        }
    } else {
        log:printError("Error: " + spreadsheetRes.toString());
    }
}
