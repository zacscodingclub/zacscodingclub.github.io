# Advanced ActiveRecord Querying

## Introduction

### What We'll Learn
* Query objects and their associations in one database hit
* Write your own custom SQL when you need to
* Perform calculations on your data and filtering by the results

## Querying belongs_to Associations
```
Person.all
/* Translates to */
SELECT "people".*
FROM "people";
```
Goald: Find all people belong to billable role

1. First try is we could simply build a join table, which will return all of the available information which ActiveRecord will then convert into Ruby objects.
```
Person.all.joins(:role)
/* Translates to */
SELECT "people".
FROM "people"
  on "roles"."id" = "people"."role_id";
```

2. Next cut is filtering out just the information we need.
```
Person.all.joins(:role).where(roles: { billable: true })
/* Translates to */
SELECT "people".*
FROM "people"
INNER JOIN "roles"
  ON "roles"."id" = "people"."role_id"
WHERE "roles"."billable" = 't';
```

3. Combining methods on the class and merging (unfortunately it doesn't quite work)
```
class Role < ActiveRecord::Base
  def self.billable
    where(billable: true)
  end
end

Person.all.merge(Role.billable)
/* Translates to */
SELECT "people".*
FROM "people"
WHERE "roles"."billable" = 't';

=> NEXT STEP

Person.joins(:role).merge(Role.billable)

/* Translates to */
SELECT "people".*
FROM "people"
INNER JOIN "roles"
  ON "roles"."id" = "people"."role_id"
WHERE "roles"."billable" = 't';

=> NEXT STEP

class Role < ActiveRecord::Base
  def self.billable
    where(billable: true)
  end
end

class Person < ActiveRecord::Base
  def self.billable
    joins(:role).merge(Role.billable)
  end
end

Person.billable

/* Translates to */
SELECT "people".*
FROM "people"
INNER JOIN "roles"
  ON "roles"."id" = "people"."role_id"
WHERE "roles"."billable" = 't';
```

## Querying has_many Associations
One Thing: With regard to data, just about anything you can do in Ruby can be done quicker and more efficiently in SQL.  Part of the reason is that each piece of data returned from the query will have to form an ActiveRecord model.  The other is that SQL is a language designed and optimized for getting data.

```ruby
# Base classes
class Person < ActiveRecord::Base
  belongs_to :location
  belongs_to :role
end

class Role < ActiveRecord::Base
  has_many :people
end

class Location < ActiveRecord::Base
  has_many :people
end
```

### Find all distinct locations with at least one person who belongs to a billable role.

```
Location.joins(:people)
/* Translates to */
SELECT "locations".*
FROM "locations"
INNER JOIN "people"
  ON "people"."locatioin_id" = "locations"."id";
```

```
Location.joins(people: :role)
/* Translates to */
SELECT "locations".*
FROM "locations"
INNER JOIN "people"
  ON "people"."locatioin_id" = "locations"."id"
INNER join "roles"
  on "roles"."id" = "people"."role_id";
```

```
Location.joins(people: :role).where(roles: { billable: true })
/* Translates to */
SELECT "locations".*
FROM "locations"
INNER JOIN "people"
  ON "people"."locatioin_id" = "locations"."id"
INNER join "roles"
  on "roles"."id" = "people"."role_id"
WHERE "roles"."billable" = 't';
```

```
Location.joins(people: :role).where(roles: { billable: true }).distinct
/* Translates to */
SELECT DISTINCT "locations".*
FROM "locations"
INNER JOIN "people"
  ON "people"."locatioin_id" = "locations"."id"
INNER join "roles"
  on "roles"."id" = "people"."role_id"
WHERE "roles"."billable" = 't';
```

### Move this into a method:
```ruby
class Location < ActiveRecord::Base
  def self.billable
    joins(people: :role).where(roles: { billable: true }).distinct
  end
end
```

### Order these locations by region name, then by location name
#### Add region model
```ruby
class Location < ActiveRecord::Base
  belongs_to :region
end

class Region < ActiveRecord::Base
  has_many :regions
end
```

```
Location.joins(:region).merge(Region.order(:name)).order(:name)
/* Translates to */
SELECT "locations".*
FROM "locations"
INNER JOIN "regions"
  ON "regions"."id" = "locations"."region_id"
ORDER BY "regions"."name" ASC, "locations"."name" ASC;

class Location < ActiveRecord::Base
  def self.by_region_and_location_name
    joins(:region).merge(Region.order(:name)).order(:name)
  end
end

# using subquery
Location.from(Location.billable, :locations)
/* Translates to */
SELECT "locations".*
FROM (
  SELECT DISTINCT "locations".*
  FROM "locations"
  INNER JOIN "people"
    ON "people"."location_id" = "locations"."id"
  INNER JOIN "roles"
    ON "roles"."id" = "people"."role_id"
  WHERE "roles"."billable" = 't'
) locations;

Location.from(Location.billable, :locations).by_region_and_location_name
ELECT "locations".*
FROM (
  SELECT DISTINCT "locations".*
  FROM "locations"
  INNER JOIN "people"
    ON "people"."location_id" = "locations"."id"
  INNER JOIN "roles"
    ON "roles"."id" = "people"."role_id"
  WHERE "roles"."billable" = 't'
) locations
INNER JOIN "regions"
  on "regions"."id" = "locations"."region_id"
ORDER BY "regions"."name" ASC, "locations"."name" ASC;
```
