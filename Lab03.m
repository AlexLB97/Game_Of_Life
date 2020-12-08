%Alex Bourdage
%Lab 3: Conway's Game of Life
%Submitted 10/13/2020

function Lab03()
%Lab03 Setup Script
neighbors = 0;
population = 0;
key = 0;
evolutions = 1;
iter = 0;

RunType = questdlg('How would you like to generate the Habitat?', 'Options:', 'From a file', 'Random generation', 'Empty to edit', 'From a file');


if (strcmp(RunType, 'From a file'))
    % Habitat = uigetfile('*.txt');
    inputfile = uigetfile('*.txt');
    Habitat = importdata(inputfile);
    HabitatHeight = size(Habitat, 1);
    HabitatWidth = size(Habitat, 2);
elseif (strcmp(RunType, 'Empty to edit'))
    Habitat = zeros(25, 25);
    HabitatWidth = 25;
    HabitatHeight = 25;
elseif (strcmp(RunType, 'Random generation'))
    HabitatDims = inputdlg({'Enter Rows: ', 'Enter Columns: ', 'Enter Population Density:'});
    HabitatHeight = str2num(HabitatDims{1});
    HabitatWidth = str2num(HabitatDims{2});
    PopDensity = str2num(HabitatDims{3});
    Habitat = randi([0 100], [HabitatHeight HabitatWidth]);
    Habitat = Habitat <= PopDensity;
    HabitatHeight = size(Habitat, 1);
    HabitatWidth = size(Habitat, 2);
end


if (~(strcmp(RunType, '')))
    figure1 = figure;
    figure1.Units = 'normalized';
    figure1.Position = [40 40 40 60]/100;
    subplot(5,3,[1 2 4 5 7 8 10 11 13 14]);
    spy(Habitat);
    set(gca, 'XTick', [], 'YTick', [], 'xlabel', []);
    title(sprintf('Generation: %d', iter));
    DuplicateHabitat = zeros(HabitatWidth, HabitatHeight);
    NeighborMatrix = zeros(3,3);

    DecisionMatrix = zeros(2,9);
    DecisionMatrix(1,4) = 1;
    DecisionMatrix(2, 3) = 1;
    DecisionMatrix(2,4) = 1;
else
    return

end

NextButton= uicontrol('Style', 'pushbutton');
NextButton.FontUnits       = 'normalized';
NextButton.FontSize        = 40/100;
NextButton.FontWeight      = 'bold';
NextButton.String          = 'Next';
NextButton.Units           = 'Normalized';
NextButton.Position        = [75 9 20 5]/100;
NextButton.BackgroundColor =[100 100 100]/100;
NextButton.ForegroundColor = [0 0 0];
NextButton.FontWeight      = 'bold';
NextButton.Callback        = @Update;

EvolutionsInput = uicontrol('Style', 'edit');
EvolutionsInput.String = '1';
EvolutionsInput.Units = 'Normalized';
EvolutionsInput.Position = [61 2 10 5]/100;
EvolutionsInput.Callback = @SetEvolutions;

EvolutionsLabel = uicontrol('Style', 'text');
EvolutionsLabel.Units = 'Normalized';
EvolutionsLabel.String = 'Number of Evolutions Per Click:';
EvolutionsLabel.FontUnits = 'normalized';
EvolutionsLabel.Position = [40 1 20 5]/100;
EvolutionsLabel.FontSize = 40/100;

EditHabitat = uicontrol('Style', 'pushbutton');
EditHabitat.Units = 'normalized';
EditHabitat.String = 'Edit Creatures';
EditHabitat.FontUnits = 'normalized';
EditHabitat.FontSize = 40/100;
EditHabitat.Position = [75 17 20 5]/100;
EditHabitat.Callback = @EditCallback;

QuitButton = uicontrol('Style', 'pushbutton');
QuitButton.Units = 'Normalized';
QuitButton.Position = [75 2 20 5]/100;
QuitButton.FontUnits = 'Normalized';
QuitButton.FontSize = 40/100;
QuitButton.String = 'Quit';
QuitButton.BackgroundColor = [1 0 0];
QuitButton.Callback = 'close all;';



    function Update(src, event)
        %update script
        for i = 1:evolutions
            iter = iter + 1;
            
            for RowIndex = 1:size(Habitat, 1)
                for ColumnIndex = 1:size(Habitat,2)
                    CellValue = Habitat(RowIndex, ColumnIndex);
                    NMStartRow = RowIndex - 1;
                    NMEndRow = RowIndex + 1;
                    NMStartCol = ColumnIndex - 1;
                    NMEndCol = ColumnIndex + 1;
                    if (NMStartRow < 1)
                        NMStartRow = size(Habitat, 1);
                    end
                    if (NMEndRow > size(Habitat, 1))
                        NMEndRow = 1;
                    end
                    if (NMStartCol < 1)
                        NMStartCol = size(Habitat, 2);
                    end
                    if (NMEndCol > size(Habitat, 2))
                        NMEndCol = 1;
                    end
                    
                    NeighborMatrix = ([Habitat(NMStartRow, NMStartCol), Habitat(NMStartRow, ColumnIndex), Habitat(NMStartRow, NMEndCol);Habitat(RowIndex, NMStartCol), Habitat(RowIndex, ColumnIndex), Habitat(RowIndex, NMEndCol);Habitat(NMEndRow, NMStartCol), Habitat(NMEndRow, ColumnIndex), Habitat(NMEndRow, NMEndCol)]);
                    neighbors = sum(sum(NeighborMatrix)) - Habitat(RowIndex, ColumnIndex);
                    DuplicateCellValue = DecisionMatrix(CellValue+1,neighbors+1);
                    if (DuplicateCellValue == 1)
                        population = population +1;
                    end
                    DuplicateHabitat(RowIndex, ColumnIndex) = DuplicateCellValue;
                    neighbors = 0;
                end
            end
            neighbors = 0;
            if (population == 0)
                fprintf('All creatures are dead after round %d.\n', iter);
                spy(Habitat);
                set(gca, 'XTick', [], 'YTick', [], 'xlabel', []);
                title(sprintf('Generation: %d', iter));
                close all;
                return
            end
            
            
            Habitat = DuplicateHabitat;
            
            spy(Habitat);
            set(gca, 'XTick', [], 'YTick', [], 'xlabel', []);
            title(sprintf('Generation: %d', iter));
            
            
            population = 0;
        end
    end

    function SetEvolutions(src, event)
        evolutions = str2num(EvolutionsInput.String);
    end

    function EditCallback(src, event)
        key = 0;
        while (key ~= 113)
            [col, row, key] = ginput(1);
            row = round(row);
            col = round(col);
            if (key~= 113)
                Habitat(row,col) = abs(Habitat(row,col)-1);
            else
                continue
            end
            spy(Habitat);
            title(sprintf('Generation: %d', iter));
            set(gca, 'XTick', [], 'YTick', [], 'xlabel', []);
        end
    end
end