# load packages -----------------------------------------------------------

library(dplyr)
library(readxl)
# library(tidyr)
# library(readxl)
library(DBI)
library(dbplyr)

library(shiny)
library(DT)
library(pool)


# read excel data ---------------------------------------------------------
# col_tpes "skip", "guess", "logical", "numeric", "date", "text" or "list".


# ff_read_all <- function(path) {
#   
#   
#   for(i in all_sheet_names) {
#     tmp <- read_excel(path, 
#                       sheet = i,
#                       col_names = TRUE,
#                       col_types = c("text","text","numeric"))
#     assign(paste0(i,"_all"),tmp,envir = .GlobalEnv)
#   }
# }


all_sheet_names <- excel_sheets("./data/表1.xlsx")

value_all_s4 <- read_excel("./data/表1.xlsx", 
                           sheet = all_sheet_names[1],
                           col_names = TRUE,
                           col_types = c("text","text","numeric"))

ratio_all_s4 <- read_excel("./data/表1.xlsx", 
                           sheet = all_sheet_names[2],
                           col_names = TRUE,
                           col_types = c("text","text","numeric"))

detail_sheet_names <- excel_sheets("./data/表2.xls")

value_detail_s4 <- read_excel("./data/表2.xls",
                              sheet = detail_sheet_names[1],
                              col_names = TRUE,
                              col_types = c(rep("text",2),rep("numeric",14)))

ratio_detail_s4 <- read_excel("./data/表2.xls",
                              sheet = detail_sheet_names[2],
                              col_names = TRUE,
                              col_types = c(rep("text",2),rep("numeric",14)))

# 读取映射表信息
index_sheet_names <- excel_sheets("./data/映射表.xlsx")

for(i in index_sheet_names) {
  tmp <- read_excel("./data/映射表.xlsx",
                    sheet = i,
                    col_names = TRUE)
  assign(paste0("index_", i), tmp, envir = .GlobalEnv)
  
}


# insert into sqlite ------------------------------------------------------

# create new sqlite database
if(!dir.exists("./database")) dir.create("./database",recursive = TRUE)
con <- dbConnect(RSQLite::SQLite(), dbname = "./database/cwyw.sqlite")

# copy dataframe to sqlite database
db_index <- setdiff(ls(pattern = ".s4$|^index.*"),"index_sheet_names")

for(i in db_index){
 copy_to(con, df=eval(as.name(i)), name=i, overwrite=TRUE) 
}

db_list_tables(con)


# shiny interface ---------------------------------------------------------




dbDisconnect(con)
rm(con)
