% Importing Data.
Data= uiimport("airport-quarterly-passenger-survey-1.csv");
% Making Table.
Data= readtable("airport-quarterly-passenger-survey-1.csv");
% Splitting Departure Time in Hours and Minuites.
Data.Dep_Time = split(Data.DepartureTime,':' );
Data.DepHour = cellfun(@str2num,Data.Dep_Time(:,1));
Data.DepMin = Data.Dep_Time(:,2);
for j=1:3501
if contains(Data.DepMin(j),"PM")
    if Data.DepHour(j) <= 11
        Data.DepHour(j) = Data.DepHour(j) + 12;
    end
end
if contains(Data.DepMin(j),"AM")
    if Data.DepHour(j) == 12
        Data.DepHour(j) = 0;
    end
end
end
% Splitting Date into Year, Month and Day.
Data.Year= year(Data.DateRecorded);
Data.Month= month(Data.DateRecorded);
Data.Day= day(Data.DateRecorded);
% Moving the Features
Data = movevars(Data, 'Month', 'Before', 'DepartureTime');
Data = movevars(Data, 'Year', 'Before', 'Month');
Data = movevars(Data, 'Day', 'Before', 'DepartureTime');
Data = movevars(Data, 'DepHour', 'Before', 'GroundTransportationTo_fromAirport');
% Deleting the unnecessary features for now.
Data.DateRecorded= [];
Data.DepartureTime= [];
Data.Dep_Time= [];
Data.DepMin= [];
% Converting into .csv file.
try
    writetable(Data,'N_Airport_Cleaned_Dataset.csv','Delimiter',',')
end
