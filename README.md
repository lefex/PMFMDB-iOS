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

#Install
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
<pre>
![](https://github.com/wsyxyxs/PMFMDB/raw/master/PMFMDB/PMFMDB/pmfmdb.gif)
</pre>
