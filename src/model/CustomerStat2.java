package model;

public class CustomerStat2 extends Customer2 {
    private int orderCount;
    private float totalRevenue;

    public CustomerStat2() {
        super();
    }

    public int getOrderCount() {
        return orderCount;
    }

    public void setOrderCount(int orderCount) {
        this.orderCount = orderCount;
    }

    public float getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(float totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
}
