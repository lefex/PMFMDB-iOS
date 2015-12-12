# PMFMDB V1.0
This is a sqlite tools to show database data and run sql, such as sqliteManager tools.
This project user FMDB, if you have this Third libs in you project, you should not include this Third libs when you install.You just input PMFMDB.

# PMFMDB Main Funcation
- You can seach all the table in you database;
- You can execute SQL;
- You can preview the result than you search;
- You can review the history you search;
- You can copy the SQL to run;
- You can select a common SQL to run;

#Usage
There is one main class in PMFMDB:
* `PMMainViewController`- The main view controller that you will present.<br>
</br>
<pre>PMMainViewController *mainViewController = [[PMMainViewController alloc] init];
  mainViewController.dataPath = [self messageDBPath];
  self.navigationController pushViewController:mainViewController animated:YES];
</pre>
<pre>
![](https://github.com/wsyxyxs/PMFMDB/raw/master/PMFMDB/PMFMDB/pmfmdb.png)
</pre>
