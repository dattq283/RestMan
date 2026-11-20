package model;

public class OrderedMenuItem2 {
    private int id;
    private int quantity;
    private float price;
    private String note;
    private float amount; // thành tiền = quantity * price, do DAO tính bằng SQL, không lưu CSDL
    private MenuItem2 menuItem;

    public OrderedMenuItem2() {
        super();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public float getAmount() {
        return amount;
    }

    public void setAmount(float amount) {
        this.amount = amount;
    }

    public MenuItem2 getMenuItem() {
        return menuItem;
    }

    public void setMenuItem(MenuItem2 menuItem) {
        this.menuItem = menuItem;
    }
}
