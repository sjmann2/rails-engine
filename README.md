## About the Project
Rails Engine is an API that exposes merchant and item data from "Little Esty Shop", a fictitious e-commerce platform where merchants and admins can manage inventory and fulfill customer invoices. 

## Built With 
   ![RoR](https://img.shields.io/badge/Ruby_on_Rails-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white)
   ![pgsql](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)

## Gems 
   ![rspec](https://img.shields.io/gem/v/rspec-rails?label=rspec&style=flat-square)
   ![shoulda](https://img.shields.io/gem/v/shoulda-matchers?label=shoulda-matchers&style=flat-square)
   ![capybara](https://img.shields.io/gem/v/capybara?label=capybara&style=flat-square)
   ![simplecov](https://img.shields.io/gem/v/simplecov?label=simplecov&style=flat-square)
   ![faker](https://img.shields.io/gem/v/faker?color=blue&label=faker)
   ![factory bot](https://img.shields.io/gem/v/factory_bot_rails?color=blue&label=factory_bot_rails)
   ![jsonapi-serializer](https://img.shields.io/gem/v/jsonapi-serializer?color=blue&label=jsonapi-serializer)

## Set Up
- Clone this repo
- `bundle install`
- `rails s`

## Database Creation
- `rails db:{create,migrate,seed}`
- `rails db:schema:dump`

## Database Structure
![Rails-Engine-Diagram](https://user-images.githubusercontent.com/99758586/197353606-8b9103de-fd2e-40ff-a45e-0bd30a231dd0.png)


## Testing Instructions

 - Clone this repo
 - in terminal (apple or integrated)    
    * bundle install
    * bundle exec rspec 

## Endpoints Available
### Base URL
``` http://localhost:3000/api/v1/ ```

#### Get all merchants

```
get /merchants
```

```
{
  "data":
    [
      {
        "id":"1",
          "type":"merchant", 
            "attributes":
              {
                "name":"Schroeder-Jerde"
                  }
                 },
        {
          "id":"2",
            "type":"merchant",
              "attributes":
                 {
                   "name":"Klein, Rempel and Jones"
                   }
                  } 
                 ]
                }

```

#### Get one merchant

```
get /merchants/<mechant_id>
```

```
{
  "data":
  {
    "id":"1",
      "type":"merchant",
      "attributes":{
        "name":"Schroeder-Jerde"
        }
      }
    }
```

#### Get all items for a given merchant ID


```
get /merchants/<merchant_id>/items
```
```
{
  "data":
    [
      {
        "id":"4",
          "type":"item",
            "attributes":
              {
                "name":"Item Nemo Facere",
                "description":"Sunt eum id eius magni consequuntur delectus veritatis. Quisquam laborum illo ut ab. Ducimus in est id voluptas autem.",
                "unit_price":42.91,
                "merchant_id":1
                }
               },
               {
                "id":"5",
                  "type":"item",
                    "attributes":
                      {
                        "name":"Item Expedita Aliquam",
                        "description":"Voluptate aut labore qui illum tempore eius. Corrupti cum et rerum. Enim illum labore voluptatem dicta consequatur. Consequatur sunt consequuntur ut officiis.",
                        "unit_price":687.23,
                        "merchant_id":1
                        }
                       }
                      ]
                     }
```
#### Get all items

```
get /items
```

```
{
  "data":
    [
      {
        "id":"4",
          "type":"item",
            "attributes":
            {
              "name":"Item Nemo Facere",
              "description":"Sunt eum id eius magni consequuntur delectus veritatis. Quisquam laborum illo ut ab. Ducimus in est id voluptas autem.",
              "unit_price":42.91,
              "merchant_id":1
              }
             },
             {
              "id":"5",
                "type":"item",
                  "attributes":
                  {
                    "name":"Item Expedita Aliquam",
                    "description":"Voluptate aut labore qui illum tempore eius. Corrupti cum et rerum. Enim illum labore voluptatem dicta consequatur. Consequatur sunt consequuntur ut officiis.",
                    "unit_price":687.23,
                    "merchant_id":1
                    }
                   }
                  ]
                 }
```

#### Get one item
``` get /items/<item_id> ```

```
{
  "data":
    {
      "id":"55",
        "type":"item",
          "attributes":
            {
              "name":"Item Delectus Dolorem",
              "description":"Et et odit sunt maxime facilis. Tenetur incidunt hic molestiae sequi tempore. Officia repellendus sit in tempore. Sit quam voluptatum qui. Labore voluptate ut perferendis suscipit ut rerum veritatis.",
              "unit_price":74.55,
              "merchant_id":3
              }
             }
            }
```

#### Create an item
```post /items```

#### Edit an item
```patch /items/<item_id>```

#### Delete an item
```delete /items/<item_id>```

### Get the merchant data for a given item ID
```get /items/<item_id>/merchant```
```
{
  "data":
    {
      "id":"3",
        "type":"merchant",
          "attributes":
            {
              "name":"Willms and Sons"
              }
             }
            }
```

### Find one item by name
```/items/find?name=accusamus```
```
{
  "data":
    {
      "id":"296",
        "type":"item",
          "attributes":
            {
              "name":"Item Accusamus Commodi",
               "description":"Quisquam ullam sit. Non autem veritatis nostrum assumenda atque. In saepe exercitationem quia. Quidem delectus nobis voluptate sunt. Odit impedit id itaque quis beatae.",
               "unit_price":532.49,
               "merchant_id":18
               }
              }
             }
```

### Find one item by minimum price
```get /items/find?min_price=250```
```
{
  "data":
    {
      "id":"2352",
        "type":"item",
          "attributes":
          {
            "name":"Item A Error",
             "description":"Exercitationem rerum porro illo quam molestiae fugiat. Est sit consequatur magnam qui. Officia fugit corporis aliquam enim consectetur.",
             "unit_price":285.96,
             "merchant_id":97
             }
            }
           }
```

### Find one item by maximum price
``` get /items/find?max_price=25 ```
``` {
    "data":
      {
        "id":"839",
          "type":"item",
            "attributes":
             {
              "name":"Item A Non",
              "description":"Ratione consequatur ipsam quia saepe voluptatem sed blanditiis. Eaque rerum eos ullam quo nostrum distinctio. Ut ad et quos sunt repellendus soluta.",
              "unit_price":14.11,
              "merchant_id":37
              }
             }
            } 
```

### Find one item by minimum and maximum price
```get /items/find?max_price=150&min_price=50```
```{
    "data":
      {
        "id":"1405",
          "type":"item",
            "attributes":
            {
              "name":"Item A Vel",
              "description":"Quae eligendi illo. Debitis ex quia quo sint quidem velit. Eaque unde delectus fuga aliquam. Ut sit libero ipsam et.",
              "unit_price":149.91,
              "merchant_id":62
              }
             }
            }
```

### Find all merchants by name
```get /merchants/find_all?name=sch```
```
{
  "data":
  [
    {
      "id":"1",
        "type":"merchant",
          "attributes":
            {
              "name":"Schroeder-Jerde"
             }
           },
           {
              "id":"20",
                "type":"merchant",
                  "attributes":
                    {
                      "name":"Schulist, Wilkinson and Leannon"
                      }
                    },
                    {
                      "id":"21",
                        "type":"merchant",
                          "attributes":
                            {
                              "name":"Leffler, Rice and Leuschke"
                             }
                           }
                         ]
                      }
```


