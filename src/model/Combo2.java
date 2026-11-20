package model;

public class Combo2 {
    private int id;
    private String name;
    private float price;
    private String description;
    private String status;
    private ComboItem2[] items;

    public Combo2() {
        super();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public ComboItem2[] getItems() {
        return items;
    }

    public void setItems(ComboItem2[] items) {
        this.items = items;
    }
}
