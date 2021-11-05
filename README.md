# PostgreSQL Range Types Overlapping Controlling ways  
Many databases do not have an additional types like "range". But after PostgreSQL 9.2 PostgreSQL has a range type. We will look at both options.

# First option
Let's assume we don't have a type like "range". In this case, we ourselves must write the code to control the range so that our ranges do not overlap.
View file manual_controlling.sql 

# Second option
In this variant, we will use the "range" type on PostgreSQL and look at this option as it is possible to automatically control the overlapping of ranges using "PostgreSQL".
View file auto_controlling.sql 
