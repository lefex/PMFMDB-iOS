# PMFMDB V1.0
This is a sqlite tools to show database data and run sql, such as sqliteManager tools.
This used FMDB. If you have FMDB in you project, you should not include it when you install.You just input PMFMDB.

# PMFMDB Main Funcation
- You can seach all the table in you database;
- You can execute SQL;
- You can preview the result than you search;
- You can review the history you search;
- You can copy the SQL to run;
- You can select a common SQL to run;

#Installation
- In the directory ./lib.  Drag PMFMDB and FMDB to you project, If you have installed FMDB, you should not drag FMDB to your project.
- Import "PMMainViewController.h" in you view controller when you use.
- You must make the database path is same to your project, and then assign to PMMainViewController

#Usage
There is one main class in PMFMDB:
* `PMMainViewController`- The main view controller that you will present.<br>
</br>
<pre>PMMainViewController *mainViewController = [[PMMainViewController alloc] init];
  mainViewController.dataPath = [self messageDBPath];
  self.navigationController pushViewController:mainViewController animated:YES];
</pre>

#All tables
* Enter to `PMFMDB` page, the main view controller.
* Click `All tables` you will enter to `PMTables` page. You can see all the tables that in you database and the SQL that create table.
* Click cell you will enter to `PMDetail`. You can search data in your table.
* Click top right corner search button, search all the data in your table.
* You can search data with condition what you what.

#Run SQL - Run sql in you data base.
* Add SQL to the file PMExecuteSql.plist which save the SQL you want to execute;
* Enter to `PMFMDB` page, the main view controller;
* Click `Execute SQL` you will enter to `PMSQL` page;
* Click the button `Local SQL`, Select the SQL that you add;
* Click button `Run SQL`

#Show search history
* Enter to `PMFMDB` page, the main view controller;
* Click `The records that you searched` you will enter to `PMCSV` page;
* Click item to preview the results
* Click top right corner trash, you will delete all the records. You should clean up all the records when you publish you APP

#The page

<pre>![](https://github.com/wsyxyxs/PMFMDB-iOS/raw/master/PMFMDB/PMFMDB/pmfmdb.png)</pre>

#Support
If you have any questions, you can send email(`wsyxyxs@126.com`) to me.

#License
PMFMDB is provided under the MIT license. See LICENSE file for details.
