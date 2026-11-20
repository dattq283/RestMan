package model;

import java.util.Date;

public class MembershipCard2 {
    private int id;
    private String cardCode;
    private Date issueDate;
    private String rank;
    private int point;
    private float discountRate;
    private Customer2 customer;

    public MembershipCard2() {
        super();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCardCode() {
        return cardCode;
    }

    public void setCardCode(String cardCode) {
        this.cardCode = cardCode;
    }

    public Date getIssueDate() {
        return issueDate;
    }

    public void setIssueDate(Date issueDate) {
        this.issueDate = issueDate;
    }

    public String getRank() {
        return rank;
    }

    public void setRank(String rank) {
        this.rank = rank;
    }

    public int getPoint() {
        return point;
    }

    public void setPoint(int point) {
        this.point = point;
    }

    public float getDiscountRate() {
        return discountRate;
    }

    public void setDiscountRate(float discountRate) {
        this.discountRate = discountRate;
    }

    public Customer2 getCustomer() {
        return customer;
    }

    public void setCustomer(Customer2 customer) {
        this.customer = customer;
    }
}
