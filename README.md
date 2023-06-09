Exploring Long-Term Datasets from Great Duck Island
================
by Eleanor Gnam and Wriley Hodge
16 March 2023
Prepared for Data Science 1: Visualization at College of the Atlantic

## Summary

Students have been collecting data on Great Duck Island (GDI) since 2000. GDI is home to a series of nesting seabirds (in order of rough abundances): Leach's Storm Petrels (Hydrobates leucorhous), Herring Gulls (Larus argentatus), Black Guillemots (Cepphus grylle), Great Black-Backed Gulls (Larus marinus), Common Eiders (Somateria mollissima), and Atlantic Puffins (Fratercula arctica). Much of the data on Great Duck is focused on these seabirds.  We chose to look at two big sets of data within the long term monitoring on Great Duck: (1) tower count, and (2) nest counts / nest mapping. Every season (which runs from approximately June 4th to July 25th each year, though some start earlier and others end later), researchers begin the day by counting every bird in sight from the tower located on the south end of Great Duck. Island wide counts of breeding gulls are also conducted at the beginning of June each year, and the sub colony on the south end of the island is also mapped into a GIS each year.

## Methods/Data Collection

Tower count:

Each morning at 0700, all researchers count every bird in sight from the tower on the south end of the island. The focus of tower count is on the four breeding species seen from the tower (both gull species, black guillemots, and common eiders) but other species are also recorded. Each species present is recorded, as is the number of individuals of each species present. The tower offers a 360-degree view of the south end of the island, including a view of many miles of ocean south of the island. Each member of the crew counts every bird, and the final number is a rough mean of the observers' counts. Observers vary in birding skill, introducing some inevitable uncertainty into that dataset. 

Nest counts and mapping: At the beginning of June, researchers count the number of nests in the gull colonies across the island. This is done by lining up at arms length from each other, and sweeping across the each colony until all nests have been flagged with a unique number and counted. The species and clutch (amount of eggs in each nest) are recorded for each nest. Over the next few days, researchers use a Trimble GPS to record the nest location of each flagged nest on the south end.


## Navigating the Project Folder

This README should be the first thing you see upon opening the folder. There are several sub-folders containing RMD and MD files. Each sub-folder should have its own data folder for the data that those files rely upon.

We mainly focused on two long-term monitoring projects: Tower Count and Colony Mapping.


-------------------------------------------------------------------------------------------------------

The `proposal` folder contains our original proposal for the project, including a data folder that the proposal.rmd file relies on, a dictionary for that data folder, and the exploratory visuals we created for our proposal.

-------------------------------------------------------------------------------------------------------
The `Data Cleaning Scripts` folder contains code that we wrote to clean up long-term data sheets and bind them into clean, master dataframes. 

`Tower Count Data` contains:
-`tower_count_data_cleaning.rmd` : the RMD file used to clean 20 years worth of tower count data and combine those files into one master data sheet
-`tower_count_data_cleaning_use_guide.md` : A markdown file that explains the functions used in the RMD file, meant to ease the process of adding future years' data
-`data` : a folder that contains the raw datasheets from 2000 - 2022, a data dictionary for those files, and the clean csv file output by the data cleaning rmd file.

The `Cleaning Nest Counts and Mapping Data` folder contains code that we wrote in order to clean and tidy all of the nest counts, shape files, and near tables (generated in GIS for calculating density).
-`data`: contains data for the following Rmds. Contains a data dictionary
-`gull_density_visualizations.Rmd` : An Rmd that reads in all the density files and habitat files, and creates a tidy csv containing all the nests on the south end, with distance to nearest 3 neighors and habitat for each nest.
-`nest count cleaning.Rmd` : An Rmd file dedicated to cleaning up the nest count data from 1999 to 2022. The output is contained within the data folder in the folder called 'nest_count_clean'
-`nest_count_spatialjoin.Rmd` : This Rmd file is dedicated to joining up the shape files of nest locations from 1999 - 2022. We were unable to write a tidy sf, so the cleaning code got copied into our final presentation rmd. 


--------------------------------------------------------------------------------------------

The `presentation` folder contains code and files used to build our presentation in Google Slides, which can be accessed here:  , it contains:

-`data`: a data folder for the clean data files that the presentation.rmd file draws upon. A data dictionary is included.
-`presentation.rmd`:  the RMD file that we used to create our presentation graphics 
-`presentation.md` : a knit markdown version of our presentation figures

-------------------------------------------------------------------------------------------------------

The `towercount_shinyapp` folder contains necessary files for the Tower Count shiny app, which can be found here: https://udppk1-eleanor-gnam.shinyapps.io/towerDRAFT/. It contains a data folder for the data file that the app draws upon, a data dictionary for that data.



## Summary of Findings

Tower Count: Generally, visualizations of tower count data confirmed our initial feelings about species trends: we've seen increasingly more gulls since the early 2000s, though Herring Gulls have recently begun to crest over and decline again. Meanwhile, our eiders and guillemots have declined. We were surprised to see how dramatic the decline in guillemots has been, and the 2023 crew plans to focus some extra attention on that species. We were surprised to notice that the diversity of species seen from the tower seems to have increased over the last 20 years. What we don't know is if this represents an actual change in the Gulf of Maine's or changing habits in data collection. 

Colony Dynamics: Our graphs show that while overall, the total number of gulls nesting on Great Duck has slightly increased, the distribution between different subcolonies has shifted considerably, with the Borofksy colony on the north end disappearing and the south end colony becoming the largest. We can also see that the distribution of nests in the south end colony has remained relatively evenly split between nesting on the rocky shoreline and the interior vegetation. The mean distance to nearest neighbor has decreased over the last 20 years, as has the overall variance in distance to nearest neighbor. We can also see that gulls consitently nest in a higher density on the berm. This raises a series of questions about how and why gulls are choosing to nest where they nest, and what it is about different habitats that facilitates different densities.


## Looking to the Future

On a broad level, we hope for future years of data collection to be added to this project so that we can continue to visualize this long term data as new data is collected. We have tried to write our code in a way that makes it easy to pipe new data into. We will also create a series of documents outlining the ideal format for data to be recorded.

This project has raised a series of questions that we think merit future work. In terms of tower count, we believe it is worth it to pay closer attention to Black Guillemots and try to assess potential causes of change and decline on GDI. We look forward to seeing any changes to the trends in nesting puffins, and visiting razorbills. In terms of the population distribution of gulls, our work raises questions about why and how gulls are choosing where to nest. Our hope is for future research to address these questions.


## Presentation

Our presentation can be found [here] (https://docs.google.com/presentation/d/1xe4_pLJs9Um9beBfaBDH1iwyRoBHbitFbG_L7tSJyc4/edit#slide=id.g2176aac9a87_0_52)

## Data

Our data came from the generations of students who conducted research at the Alice Eno Research Station on Great Duck Island, under the supervision of Professor John Anderson at College of the Atlantic. None of this data is currently published, and was all accessed from the data archive on the Island Computer (the central storage location of all things GDI related). This data archive was assembled in large part by Addison Gruber. Finally, much of the initial data entry/digitization for tower count was done by Kate Shlepr and Anne Hurley in 2013. For questions about the data used in this project, contact the authors or John Anderson. 


## Acknowledgements

We are indebted to the generations of students on GDI who put in the time and hard work to collect this data. We wish that we could name all of them. We are especially grateful to Addison Gruber, Kate Shlepr, and Anne Hurley for the earlier work they did digitizing and managing the GDI data archive. 

College of the Atlantic is one of four primary landowners on Great Duck Island. Most of the Island is owned in joint trust between the State of Maine and the Nature Conservancy. A small inholding on the North End is owned by Andra and Rich Borofsky, and the Great Duck Light itself is owned by the United States Coast Guard. We are grateful to all of these folks for their continued support and cooperation in allowing us to conduct research on their property. 

Research on GDI would not be possible without the support of Toby Stephenson and the various crew-members of the RV Osprey who provide us with logistical support and transport. 

This project benefited greatly from generous feedback and advice given by Gordon Longsworth, Hallie Arno, John Anderson, and Addison Gruber. It was prepared under the instruction and supervision of Dr. Laurie Baker. 

Finally, we wish to express our gratitude to the late Alice Eno, without whom there would be no Alice Eno Field Station. 


