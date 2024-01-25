select current_role();

use role accountadmin;
alter warehouse xxl_compute_wh suspend;

drop warehouse xxl_compute_wh;

create user john1;