  # Desafío Catálogo y sistema de pago 🚀

Para realizar este desafío debes haber estudiado previamente todo el material
disponibilizado correspondiente a la unidad.

# Parte 1 📦 

  - Andrés es dueño de una tienda online y está montando un sistema de Ecommerce. La solución que le vendieron es muy básica y sólo permite mostrar un catálogo de productos en PDF y tener un carro de compras. Toda la operación es manual y los pagos se hacen por transferencia
Andrés, te contrata para extender el ecommerce con dos funcionalidades clave:
    1. Implementar un catálogo de productos que no sea estático. Cada producto debe
estar categorizado por dos subtipos principales: Digital y Físico. Un producto digital
contiene sólo una foto y los productos físicos pueden tener muchas.
    2. Registrar los pagos. Los pagos se hacen a través de diferentes plataformas: Stripe,
Paypal y Transbank. Al pagar con Transbank puede ser con tarjeta de crédito,
webpay o oneclick.

La plataforma ya está implementada y Andrés te pide una prueba de conceptos, por lo que
tendrás que entregar lo que se detalla a continuación.

**Instrucciones**
Crear una aplicación en Rails que contenga:
1. Las migraciones y modelos para manejar los tipos de productos.
2. Las migraciones y modelos para manejar los medios de pago.
3. Un formulario para simular los medios de pago. Implementarás un modelo Orden de
Compra (básico) para poder asociarlo al pago.

Los modelos y migraciones de los tipos de productos son:
```sh
class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.timestamps
    end
  end
end
```

```sh
create_table "products", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end
```
```sh
class Product < ApplicationRecord
    has_many :orders
    has_many :product_digitals
    has_many :product_fisicos
end
```
  ```sh
create_table "product_digitals", force: :cascade do |t|
    t.string "description"
    t.integer "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_product_digitals_on_product_id"
  end
  ```
```sh
create_table "product_fisicos", force: :cascade do |t|
    t.string "description"
    t.integer "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_product_fisicos_on_product_id"
  end
´´´
´´´sh
class ProductFisico < ApplicationRecord
  belongs_to :product
end

class ProductDigital < ApplicationRecord
  belongs_to :product
end

  ```
Las migraciones y los modelos de los pago son:
```sh
class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.string :name
      t.timestamps
    end
  end
end
```
```sh
create_table "payments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end
  ```
  ```sh
class Payment < ApplicationRecord
    has_many :method_payments
    has_many :orders, through: :method_payments
end
  ```
Las migraciones y los modelos de los métodos pago son:
  ```sh
class CreateMethodPayments < ActiveRecord::Migration[6.0]
  def change
    create_table :method_payments do |t|
      t.string :description
      t.references :payment, null: false, foreign_key: true
      t.timestamps
    end
  end
end
  ```
  ```sh
create_table "method_payments", force: :cascade do |t|
    t.string "description"
    t.integer "payment_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["payment_id"], name: "index_method_payments_on_payment_id"
  end
  ```
  ```sh
class MethodPayment < ApplicationRecord
  belongs_to :payment
  belongs_to :order
end

  ```
Se debe crear los modelos `client` y `ordeer` para continuar con el sistema e-commerce
Modelos y migraciones de clientes:
  ```sh
class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.timestamps
    end
  end
end
  ```
  ```sh
create_table "clients", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end
  ```
  ```sh
class Client < ApplicationRecord
    has_many :orders
end
  ```
Modelo y migraciones de Orders
```sh
  ```sh
create_table "orders", force: :cascade do |t|
    t.integer "number"
    t.integer "client_id", null: false
    t.integer "product_id", null: false
    t.integer "payment_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "price"
    t.integer "method_payment_id"
    t.index ["client_id"], name: "index_orders_on_client_id"
    t.index ["payment_id"], name: "index_orders_on_payment_id"
    t.index ["product_id"], name: "index_orders_on_product_id"
  end
  ```
En el model `orders.rb` se debe crear el polimorfismo el cual solo permite un número de orden por cliente (no se puede repetir el mismo número de orden con otro cliente)
  ```sh
class Order < ApplicationRecord
  belongs_to :client, optional: true
  belongs_to :product, optional: true
  has_many :method_payments
  has_many :payments, through: :method_payments
  ```
 Se realizó el polimorfismo **Join Table** en el modelo `order.rb` ya que los pagos se pueden realizar de distintas formas (Stripe, Paypal y Transbank) 
 
 Para realizar el formulario de medios de pago se debe crear un form en *order* el cual se debe redirigir a un método **pago**
   ```sh
 <%= form_with(model: order, local: true,url:"/orders/pago") do |form| %>
  <% if order.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(order.errors.count, "error") %> prohibited this order from being saved:</h2>

      <ul>
        <% order.errors.full_messages.each do |message| %>
          <li><%= message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <div class="field">
    <%= form.label :number, "Order Number" %>
    <%= form.text_field :number %>
  </div>

  <div class="field">
    <%= form.label :product_id, "Select Product" %>
    <%= form.collection_select :product_id, Product.order(:name), :id, :name,{ include_blank: true} %>
  </div>

  <div class="field">  
    <%= form.label :payment_id, "Select Payment" %>
    <%= form.collection_select :payment_id, Payment.order(:name), :id, :name,{ include_blank: true} %>
  </div>

  <div class="actions">
    <%= form.submit 'Next' %>
  </div>
<% end %>
  ```
 En el controlador ´order_controller.rb´ se crea dos métodos: *pago* y *met_pago*. El primero es para obtener los datos del formulario anterior y el segundo es para guardar en la base de datos
  ```sh
  def pago
    @data = params[:order]
  end

  def met_pago
    @data = params
    
    @order = Order.new
    @order.number = params[:number]
    @order.client_id = 1
    @order.product_id = params[:product_id]
    @order.payment_id = params[:payment_id]
    @order.method_payment_id = params[:method_id]
    @order.save()

    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully success." }
    
    end
  end
  ```
 Por otra parte se crean la siguiente parte del formulario para seleccionar el método de pago
   ```sh
 <%= form_with url:"/orders/met_pago" do |f| %>

    <%= f.hidden_field :number,value:@data[:number] %>
    <%= f.hidden_field :product_id,value:@data[:product_id] %>
    <%= f.hidden_field :payment_id,value:@data[:payment_id] %>

  <div class="field">
    <%= f.select :method_id, options_for_select(
   MethodPayment.where(payment_id: @data[:payment_id]).all.map{ |p| [p.description,p.id] }) %>
  </div>

    <div class="actions">
    <%= f.submit %>
  </div>
<% end %>
  ```
# Parte 2 📦 

  - Uno de los alumnos no conoce lo que es el polimorfismo y crea registros en la base de datos haciendo operaciones del estilo:
  ```sh
  class Animal < ApplicationController
        # ...
        def create
            # ...
            kind = params[:animal][:kind]
            if kind == "Dog":
                animal = Dog.new(animal_params)
            elsif kind == "Cat"
                animal = Cat.new(animal_params)
            else
                animal = Cow.new(animal_params)
            end
        end
    end
  ```

- Instrucciones:
1. Tú, como alumno más avanzado, le ayudarás a estudiar y elaborarás un mini proyecto en Rails explicando paso a paso cómo mejorar la implementación anterior, desde la creación del proyecto hasta la inserción de datos desde consola. Tendrás que crear un diagrama con los modelos involucrados y ejemplos para que tu compañero de clase los pueda usar desde la consola de Rails.
Tip: Te recomendamos pensar en cómo se usa la especie (Dog, Cat, etc) del Animal, y cómo podríamos usar el Animal (o la tabla Animal) con varias especies distintas

Primero se debe crear un proyecto nuevo, para este caso lo llamaremos `project_animals`
```sh
rails new project_animals
```
Se crean los tres modelos de **Dog**,**Cat**, y **Cow** con atributo `name` de tipo string
```sh
rails g model Dog name
```
```sh
rails g model Cat name
```
```sh
rails g model Cow name
```
A continuación se crea el modelo **Animal** con atributo `name` que será el dato compartido con los demás modelos, para crear el polimorfismo se debe agregar la referencia polimorfica
```sh
rails g model animals name animalable:references{polymorphic}
```
Generamos la migración
```sh
rails db:migrate
```
El esquema queda de la siguiente manera:
```sh
ActiveRecord::Schema.define(version: 2021_03_02_190952) do

  create_table "animals", force: :cascade do |t|
    t.string "name"
    t.string "animalable_type", null: false
    t.integer "animalable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["animalable_type", "animalable_id"], name: "index_animals_on_animalable_type_and_animalable_id"
  end

  create_table "cats", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cows", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "dogs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
```
El diagrama del modelo debe de quedar así: 
![alt text](https://github.com/linav92/catalog_and_payment/blob/main/catalog.png?raw=true)

El siguiente paso es verificar que el modelo `animal.rb` tenga asociada la relación polimórfica
```sh
class Animal < ApplicationRecord
  belongs_to :animalable, polymorphic: true
end
```
A continuación, se asocia los modelos `dog.rb`, `cat.rb, y `cow.rb` con el modelo `animals` como `animalable``
```sh
class Dog < ApplicationRecord
    has_many :animals, as: :animalable
end

class Cat < ApplicationRecord
    has_many :animals, as: :animalable
end

class Cow < ApplicationRecord
    has_many :animals, as: :animalable
end
```

Nos dirigimos a la terminal y escribimos el comando `rails c` para abrir la consola de rails
En la consola, iniciaremos con la creación de un perrito
```sh
perrito = Dog.create(name:'Leyla')
```
Dando como resultado la creación del perro de nombre Leyla
```sh
 => #<Dog id: 1, name: "Leyla", created_at: "2021-03-02 20:14:09", updated_at: "2021-03-02 20:14:09"> 
```
Ahora debemos asociar el modelo **Dog** con el modelo **Animal**
```sh
perrito.animals << Animal.create(name: 'Leyla')
````
Como se puede observar *Leyla* pertenece a **Animal** con el *id: 1* y a su vez pertenece a la tabla **Dog** también con el *id: 1* (Esto es simple coincidencia)
```sh
 => #<ActiveRecord::Associations::CollectionProxy [#<Animal id: 1, name: "Leyla", animalable_type: "Dog", animalable_id: 1, created_at: "2021-03-02 20:14:31", updated_a
```
Crearemos otro perro de nombre *Rocky*
```sh
p2 = Dog.create(name: 'Rocky')

 => #<Dog id: 2, name: "Rocky", created_at: "2021-03-02 20:15:18", updated_at: "2021-03-02 20:15:18"> 
```
E igualmente lo asociamos con el modelo **Animal**
```sh
p2.animals << Animal.create(name: 'Rocky')

 => #<ActiveRecord::Associations::CollectionProxy [#<Animal id: 2, name: "Rocky", animalable_type: "Dog", animalable_id: 2, created_at: "2021-03-02 20:15:37", updated_at: "2021-03-02 20:15:37">]> 
```
Ahora, crearemos un gato de nombre *Nana*
```sh
gatito= Cat.create(name: 'Nana')

 => #<Cat id: 1, name: "Nana", created_at: "2021-03-02 20:16:10", updated_at: "2021-03-02 20:16:10">
```
y la asociamos el modelo **Animal**
```sh
gatito.animals << Animal.create(name: 'Nana')

 => #<ActiveRecord::Associations::CollectionProxy [#<Animal id: 3, name: "Nana", animalable_type: "Cat", animalable_id: 1, created_at: "2021-03-02 20:16:26", updated_at: "2021-03-02 20:16:26">]>
```
Como se puede observar *Nana* pertenece a **Animal** con el *id: 3* y a su vez pertenece a la tabla **Cat** con el *id: 1* ya que la tabla **Cat** solo se le ha creado un gato pero en la tabla **Animal** ya tenemos 3 animales registrados independiente de su tipo y nombre

Por último, vamos a crear una vaca
```sh
vaca = Cow.create(name: 'Lola')

=> #<Cow id: 1, name: "Lola", created_at: "2021-03-02 20:52:05", updated_at: "2021-03-02 20:52:05"> 
````
Y generamos la asociación, pero en este caso no vamos a asignarle un nombre al modelo **Animal**
```sh
vaca.animals << Animal.create
  
 => #<ActiveRecord::Associations::CollectionProxy [#<Animal id: 4, name: nil, animalable_type: "Cow", animalable_id: 1, created_at: "2021-03-02 20:52:21", updated_at: "2021-03-02 20:52:21">]>
```
Como se puede observar, el modelo no guarda el nombre pero no quiere decir que *Lola* no está asociada al animal. Podemos verificarlo llamando a modelo **Cow** (lo llamamos como variable vaca) y lo compramos con vaca.animals. Esto nos demuestra que en la tabla **Animal** *Lola* tiene **is: 4** pero si trae el **id: 1** de vaca (animalable_id: 1 es igual a Cow id: 1)
```sh
vaca.animals

 => #<ActiveRecord::Associations::CollectionProxy [#<Animal id: 4, name: nil, animalable_type: "Cow", animalable_id: 1, created_at: "2021-03-02 20:52:21", updated_at: "2021-03-02 20:52:21">]> 
 
 vaca
 
 => #<Cow id: 1, name: "Lola", created_at: "2021-03-02 20:52:05", updated_at: "2021-03-02 20:52:05">
```

Veremos todos los animales creados en nuestra aplicación
```sh
Animal.all
  
 => #<ActiveRecord::Relation [#<Animal id: 1, name: "Leyla", animalable_type: "Dog", animalable_id: 1, created_at: "2021-03-02 20:14:31", updated_at: "2021-03-02 20:14:31">, #<Animal id: 2, name: "Rocky", animalable_type: "Dog", animalable_id: 2, created_at: "2021-03-02 20:15:37", updated_at: "2021-03-02 20:15:37">, #<Animal id: 3, name: "Nana", animalable_type: "Cat", animalable_id: 1, created_at: "2021-03-02 20:16:26", updated_at: "2021-03-02 20:16:26">, #<Animal id: 4, name: nil, animalable_type: "Cow", animalable_id: 1, created_at: "2021-03-02 20:52:21", updated_at: "2021-03-02 20:52:21">]> 
```
Y veremos los animales creados en cada una de las tablas
```sh
Dog.all
 
 => #<ActiveRecord::Relation [#<Dog id: 1, name: "Leyla", created_at: "2021-03-02 20:14:09", updated_at: "2021-03-02 20:14:09">, #<Dog id: 2, name: "Rocky", created_at: "2021-03-02 20:15:18", updated_at: "2021-03-02 20:15:18">]> 
 
 Cat.all
  
 => #<ActiveRecord::Relation [#<Cat id: 1, name: "Nana", created_at: "2021-03-02 20:16:10", updated_at: "2021-03-02 20:16:10">]>
 
 Cow.all
  
 => #<ActiveRecord::Relation [#<Cow id: 1, name: "Lola", created_at: "2021-03-02 20:52:05", updated_at: "2021-03-02 20:52:05">]>
```
# Construido con 🛠️

* Ruby [2.6.6] - Lenguaje de programación usado
* Rails [6.0.3.4]  - Framework web usado
* Bootstrap [4.5.3] - Framework de CSS usado

## Autores ✒️

* **Lina Sofía Vallejo Betancourth** - *Trabajo Inicial y documentación* - [linav92](https://github.com/linav92)


## Licencia 📄

Este proyecto es un software libre. 
