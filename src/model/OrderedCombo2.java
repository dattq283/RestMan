package model;

public class OrderedCombo2 {
    private int id;
    private int quantity;
    private float price;
    private float amount; // thành tiền = quantity * price, do DAO tính bằng SQL, không lưu CSDL
    private Combo2 combo;

    public OrderedCombo2() {
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

    public float getAmount() {
        return amount;
    }

    public void setAmount(float amount) {
        this.amount = amount;
    }

    public Combo2 getCombo() {
        return combo;
    }

    public void setCombo(Combo2 combo) {
        this.combo = combo;
    }
}
